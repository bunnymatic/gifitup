require 'spec_helper'

describe ImageProcessor do

  describe ".generate_animation" do
    it 'calls convert the right number of times' do
      expect(MojoMagick).to receive(:convert).exactly(2).times
      described_class.new("it's like this").generate_animation
    end
    it 'calls convert with the right filename' do
      expect(MojoMagick).to receive(:convert).exactly(4).times
      described_class.new(%w(it's like this)).generate_animation
    end
  end

  describe ".generate_filename" do
    context '.sanitize_filename' do
      it 'prefixes with destination' do
        clean = described_class.new("the words").generate_filename('xxx')
        expect(clean).to start_with('xxx/the_words')
        expect(clean).to end_with('.gif')
      end
      it 'does not include duplicate words' do
        clean = described_class.new(%w( a a b b c c thing thing )).generate_filename('xxx')
        expect(clean).to start_with 'xxx/abcthing'
        expect(clean).to end_with('.gif')
      end
      it 'doesn\'t return HUGE filenames' do
        huge_prefix = 10.times.map{|x| 'this is the word'}.join
        clean = described_class.new(huge_prefix).generate_filename( 'xxx')
        expect(clean.length).to be >= 55
        expect(clean.length).to be <= 56
      end
    end
  end
end
