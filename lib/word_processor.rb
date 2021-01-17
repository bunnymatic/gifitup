class WordProcessor
  def initialize(words)
    @words = [words].flatten.compact
  end

  def marquee
    frames = []
    current_frame = " " + @words.join(" ")
    current_frame.length.times do
      current_frame = current_frame.scan(/./).rotate.join
      frames.push current_frame
    end
    return frames
  end
end
