require 'spec_helper'

describe Font do

  let(:font_list) { ['helvetica','courier'].map{|n| MojoMagick::Font.new(:name => n)} }
  before do
    Font.class_variable_set(:@@fonts, nil)
    MojoMagick::stub(:get_fonts => font_list)
  end


  describe '.available' do
    it 'grabs fonts from mojo_magick' do
      MojoMagick::should_receive(:get_fonts).and_return(font_list)
      expect(Font.available).to eql(font_list)
    end
  end

  describe '.default' do
    it 'returns helvetica' do
      expect(Font.default.name).to eql('helvetica')
    end
  end
end
