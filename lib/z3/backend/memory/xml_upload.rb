require 'z3/backend/memory/raw_upload'
module Z3
  module Backend
    class Memory
      class XmlData < RawUpload
        def xml
          Nokogiri.parse(data)
        end

        def xpath(path)
          xml.xpath(path)
        end

        def empty?
          data.empty?
        end
      end
    end
  end
end