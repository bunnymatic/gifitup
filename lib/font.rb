class Font
  @@fonts = nil
  def self.available
    @@fonts ||= MojoMagick::get_fonts
  end

  def self.default
    fonts = available
    font_finders = [/helv/i, /verda/i, /times/i, /book/i]
    f = nil
    font_finders.each do |re|
      f = fonts.select{|f| f.name =~ re}.first
      break if f
    end
    f
  end
end
