require 'fileutils'
require 'tmpdir'
require 'mojo_magick'

class ImageProcessor

  DEFAULT_OPTS = {
    :background_file => nil,
    :background => 'black',
    :fill => 'white',
    :gravity => 'center',
    :font => 'Helvetica-Bold',
    :pointsize => 64,
    :size => '400x400',
    :delay => 60
  }

  attr_reader :words
  def initialize(words)
    @words = [words].flatten.compact
  end

  def generate_animation(opts = {})

    outfile = opts.delete(:output_file)
    async = opts.delete(:async)
    unless outfile
      dest_dir = opts.delete(:dest_dir) || 'public/generated'
      outfile = generate_filename(dest_dir)
    end
    dest_dir = File::dirname(outfile)
    FileUtils.mkdir_p(dest_dir)

    # this pins the memory usage on heroku - maybe we shouldn't allow this

    # resize the original image first
    tmpdir = Dir.mktmpdir
    if opts[:background_file]
      new_base = generate_frame_filename('bg', tmpdir)
      MojoMagick::resize(opts[:background_file], new_base, :width => 400, :height => 400, :fill => true)
      opts[:background_file] = new_base
    end
    if async
      threads = []
      frames = words.map do |word|
        tmpname = generate_frame_filename(word, tmpdir)
        threads << Thread.new {
          generate_frame(word, opts.merge({:tempname => tmpname} ))
        }
        tmpname
      end
      threads.map(&:join)
    else
      frames = words.map do |word|
        generate_frame(word, opts)
      end
    end
    opts = DEFAULT_OPTS.merge(opts)

    MojoMagick::convert(nil,outfile) do |c|
      c.delay (opts[:delay] || 0)
      c.loop 0
      frames.each do |f|
        c.file f
      end
    end
    outfile
  end

  def generate_frame_filename(prefix, dest_dir)
    temp_gif(sanitize_filename(prefix), dest_dir)
  end

  def generate_filename(destination)
    prefix = words.uniq.join('')[0..25]
    temp_gif(sanitize_filename(prefix), destination)
  end

  private
  def generate_frame(word, opts)
    begin
      fname = opts.delete(:tempname)
      unless fname
        tmpdir = Dir.mktmpdir
        fname = generate_frame_filename(word, tmpdir)
      end

      opts = DEFAULT_OPTS.merge(opts)
      opts[:pointsize] = 6 if opts[:pointsize].to_i < 6
      src_file = opts.delete(:background_file)
      resize = (opts[:size] + '^')
      extent = opts[:size]
      if src_file
        opts[:background] = 'transparent'
      end
      opts.delete(:delay)
      opts.delete(:font)
      r = MojoMagick::convert(src_file, fname) do |c|
        c.resize resize
        c.gravity 'center'
        c.extent extent
        opts.each do |opt,val|
          c.send(opt, val)
        end
        if src_file
          c.annotate word
        else
          c.label word
        end
      end
      fname
    rescue Exception => ex
      puts "ACK", ex
      puts ex.backtrace
    end
  end

  def temp_gif(pfx, dest_dir)
    fname = nil
    Dir::Tmpname.create([pfx,'.gif']) do |path|
      fname = File.join(dest_dir, File.basename(path))
    end
    fname
  end

  def sanitize_filename(fname)
    fname.gsub(/[[:punct:]]/,'').gsub(/\s+/,'_')[0..49]
  end
end
