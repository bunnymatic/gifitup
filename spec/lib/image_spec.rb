require 'spec_helper'

describe Image do

  it '.generate_anim calls convert with the right filename' do
    MojoMagick.should_receive(:convert).with( nil, /public\/generated\/its_like_this/ ).at_least(1).times
    Image.generate_animation "it's like this"
  end

  context '.sanitize_filename' do
    it 'doesn\'t return HUGE filenames' do
      huge_prefix = 10.times.map{|x| 'this is the word'}.join
      clean = Image.send(:sanitize_filename, huge_prefix)
      expect(clean.length).to equal 50
    end
  end
end
