module Z3
  module Commands
    class DeleteBucket < Z3::Command
      def render(res)
        #http://docs.amazonwebservices.com/Amazonz3/latest/API/RESTBucketDELETE.html
        #all objects must be deleted before the bucket itself can be deleted.
        render_no_content({},204)
      end
    end
  end
end

