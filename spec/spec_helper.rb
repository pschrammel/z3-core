#nothing to do yet
require 'rack/test'

root=File.expand_path('../..', __FILE__)
$: << File.join(root, 'lib')

require 'z3-core'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

