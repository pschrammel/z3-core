module Z3
  module Commands
    class PutObject < Z3::Command
      with_data
      #http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTObjectPUT.html
      #TODO:
      #request:
      #md5 check,
      #content-disposition?,
      #check x-amz-acl  to be in: Acl: canned_acl private | public-read | public-read-write | authenticated-read | bucket-owner-read | bucket-owner-full-control
      #x-amz-server-side​-encryption
      #x-amz-storage-class

      #response:
      #x-amz-expiration
      #x-amz-server-side​-encryption
      #x-amz-version-id
      def render(res)
        render_no_content("ETag" => env["z3.upload"].md5)
      end

      def acl
        @acl ||= (amz.delete("acl") || "private")
      end
    end
  end
end