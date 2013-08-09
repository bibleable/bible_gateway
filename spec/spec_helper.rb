require 'rubygems'
require 'bundler/setup'

require 'fakeweb'
require 'bible_gateway'

RSpec.configure do |config|

end

FakeWeb.allow_net_connect = false

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end

def stub_get(url, filename, status=nil)
  options = {:response => fixture_file(filename)}
  options.merge!({:status => status}) unless status.nil?
  FakeWeb.register_uri(:get, url, options)
end
