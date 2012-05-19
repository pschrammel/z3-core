module Z3
  module Commands
    class GetService < Z3::Command
      def render(res)
        [200, {'Content-Type' => 'application/xml'},
         Z3::Responses::UserBuckets.xml(res.user, res.buckets)]
      end


      #todo: chunked

    end
  end
end