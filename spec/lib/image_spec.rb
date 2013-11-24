require 'spec_helper'

describe Image do

  it '.generate_anim calls convert with the right filename' do
    MojoMagick.should_receive(:convert).with( nil, /public\/generated\/its_like_this/ ).at_least(1).times
    Image.generate_animation "it's like this"
  end
end
