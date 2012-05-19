== Z3 Core ==

=== WTF is it? ===
Z3 Core is a a set of modules/classes that might help you to write an S3 compatible server. Z3 is splitt in a lot of levels:
 * The router, that extract what action is to be perfomed
 * The command, which represnets the action and it's params
 * The business logic, which does all the security checks and error handling
 * The storage (will be an extra package) which is resposible for the persistence of the stuff

Z3 Core is not tied to any web framework. You can use Rails, Sinatra, ... or whatever you like 
(see Z3-server which uses Goliath). The only dependency is a rack.

=== Status ===
Currently it's under heavy development. A lot of things are already working:

 * url parsing and extraction of bucket name, object name, resource and params
 * the main commands are supported (get/put/delete objects and buckets)
 * all errors have their classes
 * simple acl handling (no policies)
 * some xml generators (get bucket, set service, get bucket location)

=== TODO ===
 * Tests!!!
 * An s3 testing tool, that tests for s3 compatibility (succes, errors, permissions)
 