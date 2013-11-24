require 'rubygems'
require 'bundler'
Bundler.require :default

require 'sinatra/base'
require 'json'

Dir['./lib/**/*.rb'].each { |file| require file }

class Animacrazy < Sinatra::Base
  set :static, true
  set :root, File.dirname(__FILE__)
  set :public_folder, 'public'

  get '/' do
    fetch_fonts
    slim :index, :layout => :layout, :locals => {:frames => nil, :fonts => @fonts}
  end

  post '/' do
    fetch_fonts
    dest_dir = File.join(settings.public_folder, 'generated')
    words = params['words'].split.map(&:strip)
    font = params['font']
    frames = []
    if words && (words.length >= 1)
      anim = Image.generate_animation(words, :font => font, :dest_dir => dest_dir)
      frames = [anim.gsub(/public/,'').gsub(/^\/*/,'/')]
    end
    slim :index, :locals => {:frames => frames, :words => words, :fonts => @fonts, :font => font }
  end


  def fetch_fonts
    @fonts ||= Font.available
  end
end
