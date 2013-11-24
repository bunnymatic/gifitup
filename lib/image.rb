class Image

  def self.generate_animation(words, opts = {})
    words = [words].flatten.compact
    dest_dir = opts.delete(:dest_dir) || 'public/generated/'
    fname = temp_gif(sanitize_filename(words.join('')), dest_dir)

    opts = {
      :background => 'black',
      :fill => 'white',
      :gravity => 'center',
      :font => 'Helvetica-Bold',
      :pointsize => 72,
      :size => '500x500'
    }.merge(opts)

    r = MojoMagick::convert(nil,fname) do |c|
      c.delay 60
      c.loop 0
      words.each do |w|
        opts[:label] = w
        c.image_block do
          opts.each do |opt,val|
            c.send(opt, val)
          end
        end
      end
    end
    fname
  end

  def self.temp_gif(pfx, dest_dir)
    fname = nil
    Dir::Tmpname.create([pfx,'.gif']) do |path| 
      fname = File.join(dest_dir, File.basename(path))
    end
    fname
  end

  def self.word_as_key(word)
    sanitize_filename(word)
  end

  def self.sanitize_filename(fname)
    fname.gsub(/[[:punct:]]/,'').gsub(/\s+/,'_')
  end
end
