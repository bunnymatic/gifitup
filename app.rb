require 'rubygems'
require 'bundler'
Bundler.require :default

require 'sinatra/base'
require 'sinatra/streaming'

require 'json'

Dir['./lib/**/*.rb'].each { |file| require file }
Dir['./models/**/*.rb'].each { |file| require file }

MAX_POLLS = 500
POLL_INTERVAL = 0.4

class Animacrazy < Sinatra::Base

  helpers Sinatra::Streaming

  set :static, true
  set :root, File.dirname(__FILE__)
  set :public_folder, 'public'
  set :upload_directory, 'public/uploads'

  get '/' do
    fetch_fonts
    slim :index, :layout => :layout, :locals => {:frames => nil, :background => '#000000', :fonts => @fonts, :font => Font.default.name, :delay => 0.40 }
  end

  post '/' do
    fetch_fonts
    words = params['words'].split.map(&:strip)
    font = params['font'] || default_font
    delay = params['delay']
    font_size = params['font_size']
    background = params['background'] || '#00000'
    fill = params['fill'] || '#ffffff'
    async = false # params['async']
    file = nil
    if params.has_key? 'file'
      dest = File.join(settings.upload_directory, params['file'][:filename])
      src = params['file'][:tempfile]
      FileUtils.mkdir_p(settings.upload_directory)
      File.open(dest, "w") do |f|
        f.write(File.open(src).read)
      end
      file = dest
    end

    frames = []
    if words && (words.length >= 1)
      processor = ImageProcessor.new
      outfile = processor.generate_filename( words, storage_directory)

      opts = {
        :delay => delay.to_f * 100.0,
        :font => font,
        :pointsize => font_size,
        :background => background,
        :fill => fill,
        :background_file => file,
        :output_file => outfile,
        :async => async
      }
      polls = MAX_POLLS

      headers 'Content-Type' => 'text/html;charset=utf-8', 'Transfer-Encoding' => 'chunked'

      stream do |s|
        Thread.new {
          ImageProcessor.new.generate_animation(words, opts)
        }
        while (((polls-=1) > 0) && !(File.exists? outfile)) do
          sleep POLL_INTERVAL
          s << ''
          s.flush
          puts "wrote #{s.pos} bytes so far"
        end
        puts "Awake"

        frames = [asset_filename(outfile)]
        locals = {
          :frames => frames,
          :fonts => @fonts
        }.merge(params.slice(*%w(words font delay font_size background fill)).symbolize_keys)
        s.puts(slim :index, :locals => locals)
        s.flush
      end
    else
      locals = {
        :frames => frames,
        :fonts => @fonts
      }.merge(params.slice(*%w(words font delay font_size background fill)).symbolize_keys)

      slim :index, :locals => locals
    end
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
