module Z3
  module Responses
    class BucketLocation < Z3::Response
      def self.xml(location)
        build_xml do |x|
          x.LocationConstraint location, :xmlns => namespace
        end
      end

    end
  end
end