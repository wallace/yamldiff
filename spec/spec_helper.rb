require 'yamldiff'
require 'mocha'
require 'fakefs/spec_helpers'

RSpec.configure do |c|
  c.mock_with :mocha
  c.include FakeFS::SpecHelpers, fakefs: true
end
