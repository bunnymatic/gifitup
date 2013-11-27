class ImageProcessor

  DEFAULT_OPTS = {
    :background_file => nil,
    :background => 'black',
    :fill => 'white',
    :gravity => 'center',
    :font => 'Helvetica-Bold',
    :pointsize => 72,
    :size => '400x400',
    :delay => 60,
  }

  def generate_frame(word, opts)
    fname = opts.delete(:tempname)
    unless fname
      tmpdir = Dir.mktmpdir
      fname = generate_filename(word, tmpdir)
    end
    opts = opts.symbolize_keys

    opts = DEFAULT_OPTS.merge(opts)
    opts[:pointsize] = 6 if opts[:pointsize].to_i < 6
    src_file = opts.delete(:background_file)
    resize = (opts[:size] + '^')
    extent = opts[:size]
    if src_file
      opts[:background] = 'transparent'
    end
    opts.delete(:delay)
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
  end

  def generate_animation(words, opts = {})
    opts = opts.symbolize_keys
    async = opts.delete(:async)
    words = [words].flatten.compact
    dest_dir = opts.delete(:dest_dir)
    FileUtils.mkdir_p(dest_dir)
    fname = generate_filename(words, dest_dir)

    if async
      threads = []
      frames = words.map do |word|
        tmpdir = Dir.mktmpdir
        tmpname = generate_filename(word, tmpdir)
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

    MojoMagick::convert(nil,fname) do |c|
      c.delay (opts[:delay] || 0)
      c.loop 0
      frames.each do |f|
        c.file f
      end
    end
    fname
  end

  private
  def generate_filename(words, destination)
    dest_dir = destination
    fname = temp_gif(sanitize_filename([words].flatten.join('')), dest_dir)
    fname
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
