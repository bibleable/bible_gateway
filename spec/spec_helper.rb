require 'rubygems'
require 'bundler/setup'

require 'webmock/rspec'
require 'bible_gateway'

RSpec.configure do |config|

end

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end

def stub_get(url, filename, status=200)
  options = {:body => fixture_file(filename)}
  options.merge!({:status => status})
  stub_request(:get, url).to_return(options)
end
