module Z3
  module Commands
    class GetObject < Z3::Command

      def render(res)
        [200, add_meta(res.object.z3_meta).merge('Content-Type' => res.object.content_type || "binary/octet-stream",
                                              "Etag" => res.object.z3_etag,
                                              "Last-Modified" => to_time(res.object.z3_updated_at)),
         res.object.reader]
        #todo: acceptranges:bytes
        #todo: chunked
        #i-modified, if modified since

      end
    end
  end
end