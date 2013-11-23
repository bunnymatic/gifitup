class Font
  @@fonts = nil
  def self.available
    @@fonts ||= MojoMagick::get_fonts
  end
end
