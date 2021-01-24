class Font
  @@fonts = nil
  def self.available
    @@fonts ||= MojoMagick::available_fonts
  end

  def self.default
    fonts = available
    font_finders = [/helv/i, /verda/i, /times/i, /book/i]
    f = nil
    font_finders.each do |re|
      f = fonts.find{|f| f.name =~ re}
      break if f
    end
    f || fonts.first
  end
end
