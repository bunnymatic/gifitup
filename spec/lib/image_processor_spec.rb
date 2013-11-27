require 'spec_helper'

describe ImageProcessor do
  let(:processor) { ImageProcessor.new }
  it '.generate_anim calls convert with the right filename' do
    MojoMagick.should_receive(:convert).at_least(2).times
    processor.generate_animation "it's like this"
  end

  context '.sanitize_filename' do
    it 'doesn\'t return HUGE filenames' do
      huge_prefix = 10.times.map{|x| 'this is the word'}.join
      clean = processor.send(:sanitize_filename, huge_prefix)
      expect(clean.length).to equal 50
    end
  end
end
