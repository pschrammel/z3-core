module Z3
  module Responses
    class UserBuckets < Z3::Response
      def self.xml(_owner, _buckets)
        build_xml do |x|
          x.ListAllMyBucketsResult :xmlns => namespace do
            x.Owner do
              x.ID(_owner.z3_id)
              x.DisplayName(_owner.z3_display_name)
            end
            x.Buckets do
              _buckets.each do |_bucket|
                x.Bucket do
                  x.Name(_bucket.z3_name)
                  x.CreationDate(_bucket.z3_updated_at.iso8601) #iso8601 is not in Ruby core!
                end
              end
            end
          end
        end
      end
    end
  end
end