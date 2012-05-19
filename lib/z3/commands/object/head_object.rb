module Z3
  module Commands
    class HeadObject < Z3::Command
      def render(res)
        headers={
            'Content-Length' => res.object.content.size.to_s,
            'Content-Type' => res.object.content_type || "binary/octet-stream",
            'ETag' => res.object.z3_etag,
            'Last-Modified' => to_time(res.object.z3_updated_at)
        }.merge(add_meta(res.object.z3_meta))
        [200, headers, '']
        #todo: acceptranges:bytes
      end
    end
  end
end