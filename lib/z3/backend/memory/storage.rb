require 'z3/backend/memory/xml_upload'
require 'z3/backend/memory/upload'
module Z3
  module Backend

    #An in memory storage
    class Memory
      #we use this to pimp Ostruct
      module ContentReader
        CHUNK_SIZE = 16384 #beware this is the size we buffer in memory
        def reader(from=0)
          if content.size < CHUNK_SIZE
            content
          else
            Fiber.new do
              while data=content[from..from+CHUNK_SIZE-1]
                Fiber.yield data
                from+=CHUNK_SIZE
              end
              nil
            end
          end
        end
      end

      def initialize(options={})
        @logger=options[:logger]
        log("TYPE: MEMORY #{self.class.name}")

        @next_user_id=1111
        @secrets = {} #access_key => secret, user_id
        @users={} #user_id => user
        @users_buckets = {} #user_id => [bucket_names]
        @buckets={} # bucket_name => bucket
        @keys = {} #bucket_name => key => objects
        @uploads={}
        @guest=create_user(:z3_id => Z3::Acl::GROUP_ALL_URI,
                           :display_name => 'Guest',
                           :z3_grantee => Z3::Acl::GROUP_ALL)
        after_init
      end

      attr_reader :logger, :guest

      def start_upload(options)
        Z3::Backend::Memory::Upload.new
      end

      def start_xml(options)
        Z3::Backend::Memory::XmlUpload.new
      end

      def authorize(test_permission, user, thing)
        catch(:match) do
          thing.acl.each do |grantee, permission|
            if grantee.match?(user.z3_id, user.z3_email)
              if test_permission & permission == test_permission
                log "ACL GRANTEE MATCH: #{grantee}"
                throw :match, true
              end
            end
          end
          false
        end
      end

      #user has to support z3_id, z3_id=,z3_display_name
      def find_bucket(bucket_name)
        @buckets[bucket_name]
      end

      def find_buckets_by_user(user)
        @users_buckets[user.z3_id].map do |name|
          find_bucket(name)
        end
      end

      def delete_bucket(bucket)
        @buckets.delete(bucket.z3_name)
        @keys.delete(bucket.z3_name)
        @users_buckets[user.z3_id]= @users_buckets[user.z3_id]-[bucket.z3_name]
        nil
      end

      def create_bucket(owner, bucket_data, acl)
        bucket=OpenStruct.new(bucket_data)
        bucket.owner=owner
        bucket.acl=acl
        @buckets[bucket.z3_name]=bucket
        @keys[bucket.z3_name]={}
        (@users_buckets[owner.z3_id] ||= []) << bucket.z3_name
        bucket
      end

      def find_object(bucket, object_name)
        @keys[bucket.z3_name][object_name]
      end

      def find_objects_by_query(bucket, prefix, delimiter, marker, max_keys)
        res=OpenStruct.new(:bucket => bucket,
                           :objects => [],
                           :prefixes => [],
                           :truncated => false,
                           :marker => nil)
        matcher = /^(#{prefix})([^#{delimiter}]+)(#{delimiter}?)/
        @keys[bucket.z3_name].values.sort { |a, b| a.z3_name <=> b.z3_name }.each do |obj|
          next if marker && obj.z3_name < marker
          obj.z3_name =~ matcher
          if  $1 # got a hit?
            if res.objects.size + res.prefixes.size == max_keys
              res.truncated=true
              res.marker=obj.z3_name
              break
            end
            if $3.empty?
              res.objects << obj
            else
              cprefix = "#{$1}#{$2}#{$3}"
              res.prefixes << cprefix unless res.prefixes.last == cprefix
            end
          end
        end
        res
      end

      def create_object(bucket, object_data, acl)
        object=OpenStruct.new(object_data)
        object.extend(ContentReader)
        object.acl=acl
        @keys[bucket.z3_name][object.z3_name]=object
        object
      end

      def delete_object(bucket, object)
        @keys[bucket.z3_name].delete(object.z3_name)
        nil
      end

      #display_name
      #z3_id
      #z3_grantee
      def create_user(user_data)
        log("CREATING USER #{@next_user_id}")
        user=OpenStruct.new(user_data)
        unless user.z3_id
          user.z3_id = @next_user_id.to_s
          @next_user_id += 1
        end
        user.z3_grantee ||= Z3::Acl::CanonicalUser.new(user.z3_id)
        @users[user.z3_id] = user

        user
      end

      def add_credentials(user, access_key, secret)
        log("ADDING CREDENTIALS FOR USER #{user.z3_id}")
        @secrets[access_key] = OpenStruct.new(:access_key => access_key,
                                              :secret => secret,
                                              :z3_user_id => user.z3_id)
        nil
      end

      def find_user_by_access_key(access_key)
        _secret=@secrets[access_key]
        user=@users[_secret.z3_user_id]
        user.z3_secret=_secret.secret #this is faking the user with the right secret
        user
      end

      def find_user(user_id)
        @users[user_id]
      end

      private
      def after_init

      end

      def log(message)
        if logger
          logger.info("STORAGE: #{message}")
        end
      end

    end
  end
end
