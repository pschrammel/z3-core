module Z3
  module Commands
    class GetBucket < Z3::Command
      #http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketGET.html
      #http://docs.amazonwebservices.com/AmazonS3/latest/dev/ListingKeysUsingAPIs.html
      #http://docs.amazonwebservices.com/AmazonS3/latest/dev/ListingKeysHierarchy.html
      def render(res)
        [200, {'Content-Type' => 'application/xml'},
         Z3::Responses::BucketList.xml(res.bucket,
                                       res.objects, res.prefixes,
                                       prefix, delimiter, max_keys, res.marker, res.truncated)]
        #todo:chunked streaming, this can be huge!
      end

      def delimiter
        params['delimiter']  || "/"
      end

      def marker
        params['marker']
      end

      def max_keys
        if params['max-keys']
          params['max-keys'].to_i
        else
          1000
        end
      end

      def prefix
        params['prefix']
      end
    end
  end
end