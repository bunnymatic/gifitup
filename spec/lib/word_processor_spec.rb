require 'spec_helper'

describe WordProcessor do
  describe '#marquee' do
    it "builds a marquee list from the input words" do
      expect(WordProcessor.new("words").marquee).to eq %w(words ordsw rdswo dswor sword )
    end
  end
end