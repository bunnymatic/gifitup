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
    it 'includes fonts' do
      font = MojoMagick::available_fonts.first.name
      processor = described_class.new(%w(rock on))
      allow(processor).to receive(:generate_frame).and_call_original
      processor.generate_animation({font: font})
      expect(processor).to have_received(:generate_frame).with("rock", {font: font}).ordered
      expect(processor).to have_received(:generate_frame).with("on", {font: font}).ordered
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
        # depending on `tmpfile` generation, this could be of different lengths
        # but it should prove that it is far less than the words used to genereate
        # the filename
        expect(clean.length).to be >= 50
        expect(clean.length).to be <= 56
      end
    end
  end
end
