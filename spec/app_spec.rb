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

    
end
