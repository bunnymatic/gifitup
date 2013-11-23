class Image

  def self.generate_anim(words, opts = {})
    dest_dir = opts.delete(:dest_dir) || 'public/generated/'
    frames = words.map{|w| generate_frame(w, dest_dir, opts)}
    fname = temp_gif(words.join('').gsub(/[[:punct:]]/,''), dest_dir)
    MojoMagick::convert(nil,fname) do |c|
      c.delay 40
      c.loop 0
      frames.each do |f|
        c.file f
      end
    end

    fname
  end

  def self.generate_frame(word, dest_dir, opts = {})
    FileUtils.mkdir_p(dest_dir)
    opts = {
      :background => 'black',
      :fill => 'white',
      :gravity => 'center',
      :font => 'Helvetica-Bold',
      :pointsize => 72,
      :size => '500x500'
    }.merge(opts)

    opts[:label] = word
    k = word_as_key(word)
    fname = temp_gif(k, dest_dir) || 'unk'

    MojoMagick::convert(nil, fname) do |c|
      opts.each do |opt,val|
        c.send(opt, val)
      end
    end
    fname
  end

  def self.tempdir
    Dir::tempdir
  end

  def self.temp_gif(pfx, dest_dir)
    fname = nil
    Dir::Tmpname.create([pfx,'.gif']) do |path| 
      fname = File.join(dest_dir, File.basename(path))
    end
    fname
  end

  def self.word_as_key(word)
    word.gsub(/[[:punct:]]/,'').gsub(/\s+/,'').to_sym
  end

end
