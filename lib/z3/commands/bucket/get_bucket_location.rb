module Z3
  module Commands
    class GetBucketLocation < Z3::Command
      #http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketGETlocation.html
      #EU | eu-west-1 | us-west-1 | us-west-2 | ap-southeast-1 | ap-northeast-1 | sa-east-1 | empty string (for the US Classic Region)
      def render(res)
        #authorization #bucket owner
        [200, {'Content-Type' => 'application/xml'},
         Z3::Responses::BucketLocation.xml(res.bucket.z3_location)]
      end
    end
  end
end