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
    slim :index, :layout => :layout, :locals => {:frames => nil}
  end

  post '/' do
    dest_dir = File.join(settings.public_folder, 'generated')
    words = params['words'].split.map(&:strip)
    frames = [Image.generate_anim(words, :dest_dir => dest_dir)]
    # frames = words.map do |word|
    #   Image.generate_frame(word, :dest_dir => dest_dir )
    # end
    frames = frames.flatten.map{|f| f.gsub(/public/,'').gsub(/^\/?/,'/') }
    slim :index, :locals => {:frames => frames, :words => words}
  end

end
