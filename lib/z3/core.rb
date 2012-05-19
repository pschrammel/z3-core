module Z3
  module Core
    VERSION = "0.0.1"
  end
  MINUTES15=Rational(60*15, 86400)
  RESOURCES = ['acl', 'lifecycle', 'policy', 'location', 'logging', 'notification', 'torrent']
  LOCATIONS=['EU', 'eu-west-1', 'us-west-1', 'us-west-2', 'ap-southeast-1', 'ap-northeast-1',
             'sa-east-1', '']

end
require 'z3/utils'
require 'z3/error'
require 'z3/errors'
require 'z3/acl'
require 'z3/response'
Dir.glob(File.join(File.dirname(__FILE__), 'responses', '*.rb')).each do |file|
  require file
end

require 'z3/command'
Dir.glob(File.join(File.dirname(__FILE__), 'commands', '**', '*.rb')).each do |file|
  require file
end
module Z3
  COMMAND_MAP = Utils.map_commands(Z3::Commands::GetObject, Z3::Commands::PutObject,
                                   Z3::Commands::DeleteObject, Z3::Commands::HeadObject,
                                   Z3::Commands::GetBucketLocation, Z3::Commands::GetBucket,
                                   Z3::Commands::PutBucket, Z3::Commands::DeleteBucket,
                                   Z3::Commands::HeadBucket, Z3::Commands::GetService
  )
end
require 'z3/router'

