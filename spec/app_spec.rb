# frozen_string_literal: true

require 'spec_helper'

describe 'Gifitup' do
  include Rack::Test::Methods

  def mock_image_processor_for_app
    processor_double = instance_double(ImageProcessor)
    allow(processor_double).to receive(:generate_filename).and_return("/public#{file}")
    allow(processor_double).to receive(:generate_animation)
    allow(ImageProcessor).to receive(:new).and_return(processor_double)
    processor_double
  end

  def app
    Gifitup
  end

  describe 'get /' do
    before do
      get '/'
    end

    it 'shows an input form' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to have_tag 'form select[name=font]'
      expect(last_response.body).to have_tag 'form textarea', with: { name: 'words' }
      expect(last_response.body).to have_tag 'form #font-size-slider'
      expect(last_response.body).to have_tag 'form #delay-slider'
      expect(last_response.body).to have_tag 'form select', with: { name: 'font' }
      expect(last_response.body).to have_tag 'form input', with: { name: 'background', type: 'hidden' }
      expect(last_response.body).to have_tag 'form input', with: { name: 'fill', type: 'hidden' }
      expect(last_response.body).to have_tag 'form input', with: { type: 'submit', value: 'get it!' }
      expect(last_response.body).to have_tag 'form input', with: { type: 'submit', value: 'marquee it!' }
    end

    it 'sets the default font' do
      expect(last_response.body).to have_tag 'select option', with: { selected: 'selected' }
    end
  end

  describe 'post /' do
    let(:words) { %w[gif it up] }
    let(:file) { '/generated/animation.gif' }
    it 'generates and shows an animation' do
      processor_double = mock_image_processor_for_app
      post '/', 'words' => words.join(' ')
      wait_for do
        # Second instance of processor is in a thread
        ImageProcessor
      end.to have_received(:new).with(words).exactly(2).times
      expect(processor_double).to have_received(:generate_filename).with('public/generated')
      expect(processor_double).to have_received(:generate_animation).with(an_instance_of(Hash))
      expect(last_response.body).to have_tag('.chunk-container--results .frame img')
    end

    it 'generates marquee if the options are set' do
      processor_double = mock_image_processor_for_app
      post '/', 'words' => 'and', 'marquee' => 'yes'
      wait_for do
        # Second instance of processor is in a thread
        ImageProcessor
      end.to have_received(:new).with(['and ', 'nd a', 'd an', ' and']).exactly(2).times
      expect(processor_double).to have_received(:generate_filename).with('public/generated')
      expect(processor_double).to have_received(:generate_animation).with(an_instance_of(Hash))
      expect(last_response.body).to have_tag('.chunk-container--results .frame img')
    end

    it 'resets the form data' do
      mock_image_processor_for_app
      post '/', 'words' => words.join(' '), 'delay' => 40, 'font' => 'Helvetica', 'font_size' => 20, 'background' => '#fcfcfc', 'fill' => '#fc2'
      expect(last_response.body).to have_tag 'textarea', with: { name: 'words' }, text: words.join(' ')
      expect(last_response.body).to have_tag 'input#delay-slider', with: { value: 40 }
      expect(last_response.body).to have_tag 'input#font-size-slider', with: { value: 20 }
      expect(last_response.body).to have_tag 'form input', with: { name: 'background', value: '#fcfcfc' }
      expect(last_response.body).to have_tag 'form input', with: { name: 'fill', value: '#fc2' }
    end
  end

  describe 'get /gallery' do
    let(:files) { %w[file1.gif file2.gif] }
    before do
      expect(File).to receive(:mtime).with(files.first).and_return(Time.at(Time.now - 1000))
      expect(File).to receive(:mtime).with(files.last).and_return(Time.at(Time.now - 100))
      allow(Dir).to receive(:glob).and_return(files)
    end
    it 'renders the found files' do
      get '/gallery'
      files.each do |f|
        expect(last_response.body).to have_tag 'img', with: { src: "/#{f}" }
      end
    end
    it 'renders the only the `limit` number of files if that parameter is given' do
      get '/gallery?limit=1'
      expect(last_response.body).to have_tag 'img', with: { src: "/#{files.last}" }
    end
  end
end
