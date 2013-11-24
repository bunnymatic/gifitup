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
    words = params['words'].split.map(&:strip)
    font = params['font']
    frames = []
    if words && (words.length >= 1)
      anim = Image.generate_animation(words, :font => font, :dest_dir => storage_directory)
      frames = [asset_filename(anim)]
    end
    slim :index, :locals => {:frames => frames, :words => words, :fonts => @fonts, :font => font }
  end

  get '/gallery' do
    limit = (params["limit"] || 10).to_i
    all_files = Dir.glob(File.join(storage_directory, '*.gif'))
    sorted_files = all_files.sort_by{ |f| -1*File.mtime(f).to_i }
    limit -= 1
    trimmed_files = sorted_files[0..limit].map{|f| asset_filename(f)}
    slim :gallery, :locals => {:files => trimmed_files}
  end

  def asset_filename(fname)
    fname.gsub(/public/,'').gsub(/^\/*/,'/')
  end

  def fetch_fonts
    @fonts ||= Font.available
  end

  def storage_directory
    File.join(settings.public_folder, 'generated')
  end
end
