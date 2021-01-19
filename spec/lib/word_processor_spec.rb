require 'spec_helper'

describe WordProcessor do
  describe '#marquee' do
    it "builds a marquee list from the input words" do
      expected = [
        "a can ",
        " can a",
        "can a ",
        "an a c",
        "n a ca",
        " a can",
      ]
      expect(WordProcessor.new("a can").marquee).to eq expected
    end
  end
end
