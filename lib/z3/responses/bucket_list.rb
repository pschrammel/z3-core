module Z3
  module Responses
    class BucketList < Z3::Response
      def self.xml(bucket, contents, prefixes=nil, prefix='', delimiter=nil, max_keys=nil, marker='', truncated=false)
        build_xml do |x|
          x.ListBucketResult :xmlns => namespace do
            x.Name bucket.z3_name
            x.Prefix prefix if prefix
            x.Marker marker if marker
            x.Delimiter delimiter if delimiter
            x.MaxKeys max_keys if max_keys
            x.IsTruncated truncated
            contents.each do |c|
              x.Contents do
                x.Key c.z3_name
                x.LastModified c.z3_updated_at.iso8601
                x.ETag c.z3_etag
                x.Size c.z3_size
                x.StorageClass "STANDARD"
                x.Owner do
                  x.ID c.z3_owner_id
                  x.DisplayName 'TBD'
                end
              end
            end
            if prefixes
              prefixes.each do |p|
                x.CommonPrefixes do
                  x.Prefix p
                end
              end
            end
          end
        end
      end

    end
  end
end