#!/usr/bin/env ruby

require_relative "../lib/image_processor"
require_relative "../lib/word_processor"

puts "Generating ..."

words = ARGV
if ARGV.length == 1
  words = WordProcessor.new(ARGV).marquee
end
puts ImageProcessor.new(words).generate_animation({output_file: "generated.gif", delay: 20})
