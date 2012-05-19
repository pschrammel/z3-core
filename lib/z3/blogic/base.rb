module Z3
  module Blogic
    class Base
      def initialize(storage, command, logger)
        @storage = storage
        @logger=logger
        @command=command

        @user=user_auth
      end

      attr_reader :logger, :storage, :command, :user

      def execute
        command.render(send(command.name))
      end

      def start_upload(options={})
        command.upload= storage.start_upload(options)
      end

      def start_xml(options={})
        command.xml= storage.start_xml(options)
      end

      private

      #service operations
      def get_service
        log("GET SERVICE")
        only_authorized
        buckets=storage.find_buckets_by_user(user)
        OpenStruct.new(:user => user, :buckets => buckets)
      end

      #bucket operations

      def delete_bucket
        log("DELETE BUCKET: #{command.bucket_name}")
        bucket=storage.find_bucket(command.bucket_name)
        raise Z3::Errors::NoSuchBucket.new(command.path_info) unless bucket
        only_bucket_owner(bucket)
        storage.delete_bucket(bucket, user)
      end

      def put_bucket
        #TODO:
        #check for existence
        #what if I'm already owner?
        log("PUT BUCKET: #{command.bucket_name}, acl: #{command.acl}, location: #{command.location}")
        only_authorized
        bucket_data={:z3_name => command.bucket_name,
                     :z3_updated_at => Time.now,
                     :z3_location => command.location}
        acl=Z3::Acl.extract_grants(command.amz, command.acl, user.z3_grantee)
        log_acl(acl)
        bucket=storage.create_bucket(user, bucket_data, acl)
        nil
      end


      def get_bucket
        log("GET BUCKET: #{command.bucket_name}, delimiter: #{command.delimiter.inspect}, marker: #{command.marker.inspect}, max-keys: #{command.max_keys.inspect}, prefix: #{command.prefix.inspect}")
        bucket=storage.find_bucket(command.bucket_name)
        raise Z3::Errors::NoSuchBucket.new(command.path_info) unless bucket
        only_read(bucket)
        storage.find_objects_by_query(bucket, command.prefix,
                                      command.delimiter, command.marker, command.max_keys)
      end

      def get_bucket_location
        log("GET BUCKET LOCATION: #{command.bucket_name}")
        bucket=storage.find_bucket(command.bucket_name)
        raise Z3::Errors::NoSuchBucket.new(command.path_info) unless bucket
        only_read(bucket)
        OpenStruct.new(:bucket => bucket)
      end

      def get_object
        log("GET OBJECT: #{command.bucket_name},#{command.object_name}")
        bucket=storage.find_bucket(command.bucket_name)
        raise Z3::Errors::NoSuchBucket.new(command.path_info) unless bucket
        object = storage.find_object(bucket, command.object_name)
        raise Z3::Errors::NoSuchKey.new(command.path_info) unless object
        only_read(object)
        OpenStruct.new(:object => object)
      end

      def head_object
        get_object
      end

      def put_object
        log("PUT OBJECT: #{command.bucket_name},#{command.object_name}, #{command.upload.size}")
        bucket=storage.find_bucket(command.bucket_name)
        raise Z3::Errors::NoSuchBucket.new(command.path_info) unless bucket
        only_write(bucket)
        #TODO: check md5 and raise

        object_data={:z3_name => command.object_name,
                     :z3_updated_at => Time.now,
                     :z3_owner_id => 1111, #TODO
                     :z3_size => command.upload.size,
                     :z3_etag => command.upload.md5,
                     :z3_meta => command.meta,
                     :content => command.upload.data,
                     :content_type => command.content_type}
        acl=Z3::Acl.extract_grants(command.amz, command.acl, bucket.owner.z3_grantee, user.z3_grantee)
        log_acl(acl)
        object=storage.create_object(bucket, object_data, acl)
        OpenStruct.new(:object => object)
      end

      def delete_object
        log("DELETE OBJECT: #{command.bucket_name},#{command.object_name}")
        bucket=storage.find_bucket(command.bucket_name)
        raise Z3::Errors::NoSuchBucket.new(command.path_info) unless bucket
        only_write(bucket)
        object=storage.find_object(bucket, command.object_name)
        storage.delete_object(bucket, object)
        nil
      end

      #=============== Helper stuff
      def user_auth
        if command.access_key
          user=storage.find_user_by_access_key(command.access_key)
          #is this like this or is there a fallback to guest?
          raise Z3::Errors::AccessDenied.new(command.path_info) unless command.valid_signature?(user.z3_secret)
        else
          user=storage.guest
        end
        log "USER #{user.z3_grantee}"
        user
      end

      #raises error if user is anonymous
      def only_authorized
        raise Z3::Errors::AccessDenied.new(command.path_info) unless user.z3_grantee.authenticated?
      end

      def only_bucket_owner(bucket)
        raise Z3::Errors::AccessDenied.new(command.path_info) unless user == bucket.owner
      end

      def only_read(thing)
        only_permission(thing, Z3::Acl::PERMISSION_READ)
      end

      def only_write(thing)
        only_permission(thing, Z3::Acl::PERMISSION_WRITE)
      end

      def only_permission(thing, permission)
        raise Z3::Errors::AccessDenied.new(command.path_info) unless storage.authorize(permission, user, thing)
      end

      def log(message)
        if logger
          logger.info("BACKEND: #{message}")
        end
      end

      def log_acl(acls)
        acls.each do |acl|
          log("ACL: #{acl[0]} : #{Z3::Acl.acl_to_s(acl[1])}")
        end
      end
    end
  end
end