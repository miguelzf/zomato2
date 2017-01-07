require 'rubygems'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'zomato2'

#require 'minitest'
#require 'minitest/autorun'
require 'webmock/rspec'
require 'vcr'
require 'dotenv'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
end

# Matcher to see if a string is a URL or not.
RSpec::Matchers.define :be_url do |expected|
  # The match method, returns true if valie, false if not.
  match do |actual|
    # Use the URI library to parse the string, returning false if this fails.
    URI.parse(actual) rescue false
  end
end

# load env vars
Dotenv.load
