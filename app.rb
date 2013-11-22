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

  get '/generate' do
    slim :generate, :layout => :layout, :locals => {:frames => nil}
  end

  post '/generate' do
    words = params['words'].split.map(&:strip)
    frames = words.map do |word|
      Image.generate_frame(word, :dest_dir => File.join(settings.public_folder, 'generated'))
    end
    frames = frames.map{|f| f.gsub(/public/,'').gsub(/^\/?/,'/') }
    slim :generate, :locals => {:frames => frames, :words => words}
  end

end
