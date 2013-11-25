require 'spec_helper'

describe Font do
  before do
    font_list = 
    Font.class_variable_set(@@fonts, nil)
    MojoMagick::stubs(:get_fonts, font_list)
  end


  describe '.available' do
    it 'grabs fonts from mojo_magick' do
    end
  end

  describe '.default' do
  end
end
