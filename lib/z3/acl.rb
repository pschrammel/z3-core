#http://docs.amazonwebservices.com/AmazonS3/latest/dev/ACLOverview.html
module Z3
  module Acl
    #emailAddress="xyz@amazon.com", id="6757687zuzt",uri="http://acs.amazonaws.com/groups/global/AllUsers"
    class Base
      def initialize(identifier, short=nil, authenticated=true)
        @identifier=identifier
        @short=short
        @authenticated=authenticated
      end

      attr_reader :identifier, :short

      def authenticated?
        @authenticated
      end

      #match a user with a specific id to this
      def match?(id, email)
        return true unless authenticated? #always match on "all" group
        return false if id == GROUP_ALL_URI # all does not match anything
        id == identifier || email == identifier
      end

      def to_s
        "#{type}: #{short || identifier}"
      end
    end
    class Group < Base

      def type
        'group'
      end
    end
    class CanonicalUser < Base
      def type
        'id'
      end
    end
    class CustomerByEmail < Base
      def type
        'email'
      end
    end
    GROUP_AUTHENTICATED_URI="http://acs.amazonaws.com/groups/global/AuthenticatedUsers"
    GROUP_ALL_URI="http://acs.amazonaws.com/groups/global/AllUsers"
    GROUP_LOGDELIVERY_URI="http://acs.amazonaws.com/groups/s3/LogDelivery"

    GROUP_AUTHENTICATED=Group.new(GROUP_AUTHENTICATED_URI, 'authenticated')
    GROUP_ALL=Group.new(GROUP_ALL_URI, 'all', false)
    GROUP_LOGDELIVERY=Group.new(GROUP_LOGDELIVERY_URI, 'log')
    GROUPS={
        GROUP_LOGDELIVERY_URI => GROUP_LOGDELIVERY,
        GROUP_ALL_URI => GROUP_ALL,
        GROUP_AUTHENTICATED_URI => GROUP_AUTHENTICATED
    }


    #http://docs.amazonwebservices.com/AmazonS3/latest/dev/UsingACLsandBucketPoliciesTogether.html
    PERMISSION_READ = 2**0  #Object: s3:GetObject, s3:GetObjectVersion, s3:GetObjectTorrent; Bucket:s3:ListBucket, s3:ListBucketVersions,s3:ListBucketMultipartUploads
    PERMISSION_WRITE = 2**1 #bucket: s3:PutObject,s3:DeleteObject,s3:DeleteObjectVersion
    PERMISSION_READ_ACL = 2**2     #Object: s3:GetObjectAcl, s3:GetObjectVersionAcl; Bucket:s3:GetBucketAcl
    PERMISSION_WRITE_ACL = 2**3    #Object:: s3:PutObjectAcl, s3:PutObjectVersionAcl; Bucket:s3:PutBucketAcl
    PERMISSION_FULL_CONTROL= PERMISSION_READ | PERMISSION_WRITE | PERMISSION_READ_ACL | PERMISSION_WRITE_ACL
    PERMISSIONS = {
        'read' => PERMISSION_READ,
        'write' => PERMISSION_WRITE,
        'read-acl' => PERMISSION_READ_ACL,
        'write-acl' => PERMISSION_WRITE_ACL,
        'full-control' => PERMISSION_FULL_CONTROL
    }
    CANNED_ACL= ['private', 'public-read', 'public-read-write', 'authenticated-read', 'bucket-owner-read',
                 'bucket-owner-full-control']
    HEADER_ACL= {"grant-read" => PERMISSION_READ,
                 "grant-write" => PERMISSION_WRITE,
                 "grant-read-acp" => PERMISSION_READ_ACL,
                 "grand-write-acp" => PERMISSION_WRITE_ACL,
                 "grant-full-control" => PERMISSION_FULL_CONTROL}
    ACL_USER_TYPE = {'id' => CanonicalUser, "uri" => Group, "emailAddress" => CustomerByEmail}

    def self.acl_to_s(acl)
      if acl==PERMISSION_FULL_CONTROL
        'full-control'
      else
        PERMISSIONS.map { |name, bit|
          next if bit == PERMISSION_FULL_CONTROL
          name unless 0 == (acl & bit)
        }.compact.join(', ')
      end
    end

    def self.extract_grants(amz_headers, canned_acl, bucket_owner = nil, object_owner = nil)
      from_headers=grants_of_headers(amz_headers, bucket_owner, object_owner)
      if from_headers.empty?
        grants_of_canned_acl(canned_acl, bucket_owner, object_owner)
      else
        from_headers
      end
    end

    def self.grants_of_canned_acl(acl, bucket_owner, object_owner=nil)
      the_owner=object_owner || bucket_owner
      acl='private' unless CANNED_ACL.include?(acl)
      res=[]
      case acl
        when 'private'
          res << [the_owner, PERMISSION_FULL_CONTROL]
        when 'public-read'
          res << [the_owner, PERMISSION_FULL_CONTROL]
          res << [GROUP_ALL, PERMISSION_READ]
        when 'public-read-write'
          res << [the_owner, PERMISSION_FULL_CONTROL]
          res << [GROUP_ALL, PERMISSION_WRITE]
          res << [GROUP_ALL, PERMISSION_READ]
        when 'authenticated-read'
          res << [the_owner, PERMISSION_FULL_CONTROL]
          res << [GROUP_AUTHENTICATED, PERMISSION_READ]
        when 'bucket-owner-read' && object_owner
          res << [object_owner, PERMISSION_FULL_CONTROL]
          res << [bucket_owner, PERMISSION_READ]
        when 'bucket-owner-full-control' && object_owner
          res << [object_owner, PERMISSION_FULL_CONTROL]
          res << [bucket_owner, PERMISSION_FULL_CONTROL]
      end
      res
    end

    def self.grants_of_headers(headers, bucket_owner, object_owner)
      res = []
      HEADER_ACL.each do |header_name, acl|
        if grantees_s=headers.delete(header_name) #we'll remove the acl headers
          grantees=grantees_s.split(",") # I hope there are no commas in the email adresses
          grantees.each do |grantee|
            grantee.strip.match(/^(.+)="(.+)"/)
            if klass=ACL_USER_TYPE[$1]
              if $1=='uri'
                next unless the_group=GROUPS[$2]
                res << [the_group, acl]
              else
                res << [klass.new($2), acl]
              end
            end
          end
        end
      end
      unless res.empty?
        res << [object_owner || bucket_owner, PERMISSION_FULL_CONTROL]
      end
      res
    end
  end
end