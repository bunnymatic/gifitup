require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'
require 'rspec-html-matchers'

require File.join(File.dirname(__FILE__), '..', 'app.rb')

set :environment, :test

RSpec.configure do |config|
  config.include RSpecHtmlMatchers
end
