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
    slim :index, :layout => :layout, :locals => {:frames => nil, :fonts => @fonts, :font => Font.default.name}
  end

  post '/' do
    fetch_fonts
    words = params['words'].split.map(&:strip)
    font = params['font'] || default_font
    delay = params['delay']
    font_size = params['font_size']
    frames = []
    if words && (words.length >= 1)
      opts = {
        :delay => delay.to_f * 100.0,
        :font => font,
        :dest_dir => storage_directory,
        :pointsize => font_size
      }
      anim = Image.generate_animation(words, opts)
      frames = [asset_filename(anim)]
    end

    locals = {
      :frames => frames,
      :fonts => @fonts
    }.merge(params.slice(*%w(words font delay font_size)).symbolize_keys)

    slim :index, :locals => locals
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

  def default_font
    Font.default
  end

  def storage_directory
    File.join(settings.public_folder, 'generated')
  end
end
