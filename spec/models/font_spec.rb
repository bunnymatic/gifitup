# frozen_string_literal: true

require 'spec_helper'

describe Font do
  let(:font_list) { %w[helvetica courier].map { |n| MojoMagick::Font.new(name: n) } }
  before do
    Font.class_variable_set(:@@fonts, nil)
    allow(MojoMagick).to receive(:available_fonts).and_return(font_list)
  end

  describe '.available' do
    it 'grabs fonts from mojo_magick' do
      expect(MojoMagick).to receive(:available_fonts).and_return(font_list)
      expect(Font.available).to eql(font_list)
    end
  end

  describe '.default' do
    it 'returns helvetica' do
      expect(Font.default.name).to eql('helvetica')
    end

    describe 'when helvetica isn\'t available' do
      let(:font_list) { ['whatever', 'whatever bold'].map { |n| MojoMagick::Font.new(name: n) } }

      it 'returns the first font' do
        expect(Font.default.name).to eql 'whatever'
      end
    end
  end
end
