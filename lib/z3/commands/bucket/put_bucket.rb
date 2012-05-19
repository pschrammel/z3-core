module Z3
  module Commands
    class PutBucket < Z3::Command
      with_xml
      #http://docs.amazonwebservices.com/AmazonS3/latest/dev/BucketRestrictions.html
      #http://docs.amazonwebservices.com/Amazonz3/latest/API/RESTBucketPUT.html


      # <CreateBucketConfiguration><LocationConstraint>EU</LocationConstraint></CreateBucketConfiguration>

      #Bucket names must be between 3 and 63 characters long
      #Bucket name must be a series of one or more labels separated by a period (.), where each label:
      #Must start with a lowercase letter or a number
      #Must end with a lowercase letter or a number
      #Can contain lowercase letters, numbers and dashes
      #Bucket names must not be formatted as an IP address (e.g., 192.168.5.4)
      def render(res)
        render_no_content("Location" => path_info)
      end


      #EU | eu-west-1 | us-west-1 | us-west-2 | ap-southeast-1 | ap-northeast-1 | sa-east-1 | empty string (for the US Classic Region)
      def location
        return nil if xml.empty?
        xml.xpath("/CreateBucketConfiguration/LocationConstraint").text
      end

      def acl
        @acl ||= (amz.delete("acl") || "private")
      end

    end
  end
end