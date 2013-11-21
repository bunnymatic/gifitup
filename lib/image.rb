class Image

  def self.generate_frame(word,opts = {})
    dest_dir = opts.delete(:dest_dir) || 'public/generated/'
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
    fname = 'unk'
    Dir::Tmpname.create([k,'.gif']) do |path| 
      fname = File.join(dest_dir, File.basename(path))
    end

    #convert -background lightblue -fill blue -font Candice -pointsize 72 label:Anthony label.gif
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

  def self.word_as_key(word)
    word.gsub(/[[:punct:]]/,'').gsub(/\s+/,'').to_sym
  end

end
