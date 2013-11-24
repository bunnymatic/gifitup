require 'spec_helper'

describe 'Animacrazy' do
  include Rack::Test::Methods

  def app
    Animacrazy
  end

  describe 'get /' do

    it 'shows an input form' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to have_tag 'form select[@name=font]'
      expect(last_response.body).to have_tag 'form textarea[@name=words]'
    end

  end

  describe 'post /' do
    let(:words) { %w(gif it up) }
    let(:file) { '/generated/animation.gif' }
    it 'generates and shows an animation' do
      Image.should_receive(:generate_animation).with(words, an_instance_of(Hash)).and_return('/public' + file)
      post '/', "words" => words.join(' ')
      expect(last_response.body).to have_tag "img[@src=#{file}]"
    end

  end

  describe 'get /gallery' do
    let(:files) { %w(file1.gif file2.gif) }
    before do
      File.should_receive(:mtime).with(files.first).and_return(Time.at(Time.now - 1000))
      File.should_receive(:mtime).with(files.last).and_return(Time.at(Time.now - 100))
      Dir.stub(:glob => files)
    end
    it 'renders the found files' do
      get '/gallery'
      files.each do |f|
        expect(last_response.body).to have_tag "img[@src=/#{f}]"
      end
    end
    it 'renders the found files' do
      get '/gallery?limit=1'
      expect(last_response.body).to have_tag "img[@src=/#{files.last}]"
    end
  end
end
