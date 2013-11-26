require 'spec_helper'

describe Image do
  context 'initialize' do
    it 'constructs a new image' do
      i = Image.new 'file.gif'
      expect(i.filename).to eql 'file.gif'
    end
  end
end
