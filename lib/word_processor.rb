class WordProcessor
  def initialize(words)
    @words = [words].flatten.join(" ").strip
  end

  def marquee
    frames = []
    @words.length.times do
      frames.push @words.rotate
    end
    return words
  end
end
