require 'spec_helper'

describe 'Animacrazy' do
  include Rack::Test::Methods

  def app
    Animacrazy
  end

  describe 'get /' do

    before do
      get '/'
    end

    it 'shows an input form' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to have_tag 'form select[@name=font]'
      expect(last_response.body).to have_tag 'form textarea[@name=words]'
    end

    it 'sets the default font' do
      pending
      expect(last_response.body).to have_tag "select option", :with => {:selected => 'selected'}
    end

  end

  describe 'post /' do
    let(:words) { %w(gif it up) }
    let(:file) { '/generated/animation.gif' }
    it 'generates and shows an animation' do
      Image.should_receive(:generate_animation).with(words, an_instance_of(Hash)).and_return('/public' + file)
      post '/', "words" => words.join(' ')
      expect(last_response.body).to have_tag "img", :with => {:src => file}
    end

    it 'sets the form data' do
      Image.stub(:generate_animation => '/public' + file)
      post '/', "words" => words.join(' '), 'delay' => 40, 'font' => 'Helvetica'
      expect(last_response.body).to have_tag "textarea", :with => {:name => 'words'}, :text => words.join(' ')
      expect(last_response.body).to have_tag "input#delay-slider", :with => {:value => 40}
      expect(last_response.body).to have_tag "select option", :with => {:selected => 'selected'}, :text => 'Helvetica'
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
        expect(last_response.body).to have_tag "img", :with => { :src => "/#{f}"}
      end
    end
    it 'renders the found files' do
      get '/gallery?limit=1'
      expect(last_response.body).to have_tag "img", :with => { :src => "/#{files.last}"}
    end
  end
end
