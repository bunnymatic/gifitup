#!/usr/bin/env ruby

require_relative "../lib/image_processor"

puts "Generating ..."

puts ImageProcessor.new(ARGV).generate_animation({output_file: "generated.gif"})
