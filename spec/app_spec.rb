require 'spec_helper'

describe 'Gifitup' do
  include Rack::Test::Methods

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
      expect(last_response.body).to have_tag 'form textarea', with: {name: 'words'}
      expect(last_response.body).to have_tag 'form #font-size-slider'
      expect(last_response.body).to have_tag 'form #delay-slider'
      expect(last_response.body).to have_tag 'form select', with: {name: 'font'}
      expect(last_response.body).to have_tag 'form input', with: {name: 'background', type: "hidden"}
      expect(last_response.body).to have_tag 'form input', with: {name: 'fill', type: "hidden"}
    end

    it 'sets the default font' do
      expect(last_response.body).to have_tag "select option", with: {selected: 'selected'}
    end

  end

  describe 'post /' do
    let(:words) { %w(gif it up) }
    let(:file) { '/generated/animation.gif' }
    it 'generates and shows an animation' do
      allow_any_instance_of(ImageProcessor).to receive(:generate_animation).with(words, an_instance_of(Hash)).and_return('/public' + file)
      post '/', "words" => words.join(' ')
      expect(last_response.body).to have_tag(".chunk-container--results .frame img")
    end

    it 'sets the form data' do
      allow_any_instance_of(ImageProcessor).to receive(:generate_animation).and_return('/public' + file)
      post '/', "words" => words.join(' '), 'delay' => 40, 'font' => 'Helvetica', 'font_size' => 20, 'background' => '#fcfcfc', 'fill' => '#fc2'
      expect(last_response.body).to have_tag "textarea", with: {name: 'words'}, text: words.join(' ')
      expect(last_response.body).to have_tag "input#delay-slider", with: {value: 40}
      expect(last_response.body).to have_tag "input#font-size-slider", with: {value: 20}
      expect(last_response.body).to have_tag 'form input', with: {name: 'background', value: '#fcfcfc'}
      expect(last_response.body).to have_tag 'form input', with: {name: 'fill', value: '#fc2'}
    end

  end

  describe 'get /gallery' do
    let(:files) { %w(file1.gif file2.gif) }
    before do
      expect(File).to receive(:mtime).with(files.first).and_return(Time.at(Time.now - 1000))
      expect(File).to receive(:mtime).with(files.last).and_return(Time.at(Time.now - 100))
      allow(Dir).to receive(:glob).and_return(files)
    end
    it 'renders the found files' do
      get '/gallery'
      files.each do |f|
        expect(last_response.body).to have_tag "img", with: { src: "/#{f}"}
      end
    end
    it 'renders the found files' do
      get '/gallery?limit=1'
      expect(last_response.body).to have_tag "img", with: { src: "/#{files.last}"}
    end
  end
end
