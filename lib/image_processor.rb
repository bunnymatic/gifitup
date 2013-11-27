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
    :unsharp => "0x0.8"
  }

  def generate_animation(words, opts = {})
    opts.symbolize_keys!
    words = [words].flatten.compact
    fname,dir = generate_filename(words, opts.delete(:dest_dir))
    FileUtils.mkdir_p(dir)

    opts = DEFAULT_OPTS.merge(opts)
    opts[:pointsize] = 6 if opts[:pointsize].to_i < 6
    src_file = opts.delete(:background_file)
    resize = (opts[:size] + '^')
    extent = opts[:size]
    if src_file
      opts[:background] = 'transparent'
    end
    r = MojoMagick::convert(nil, fname) do |c|
      c.resize resize
      c.gravity 'center'
      c.extent extent
      c.delay opts.delete(:delay)
      c.loop 0

      words.each do |w|
        opts[:label] = w
        c.image_block do
          c.resize resize
          c.extent extent
          c.compose 'Multiply'
          c.file src_file
          opts.each do |opt,val|
            c.send(opt, val)
          end
        end
      end
    end
    fname
  end

  private
  def generate_filename(words, destination = nil)
    dest_dir = destination || 'public/generated/'
    fname = temp_gif(sanitize_filename(words.join('')), dest_dir)
    [fname, dest_dir]
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
