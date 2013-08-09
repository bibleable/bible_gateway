require 'rubygems'
require 'bundler/setup'

require 'bible_gateway'

RSpec.configure do |config|

end

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end

def stub_get(url, filename, status=200)
  response = Typhoeus::Response.new(:code => status, :body => fixture_file(filename))
  Typhoeus.stub(url).and_return(response)
end
