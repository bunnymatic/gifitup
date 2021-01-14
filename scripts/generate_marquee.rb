#!/usr/bin/env ruby

word = ARGV.join.scan(/./).compact

puts "Generating for #{word}"

current = word
word.length.times do |index|
  first_letter = current.shift
  current.push first_letter
  print current.join
  print " "
end
puts
