require 'z3/backend/memory/raw_upload'
module Z3
  module Backend
    class Memory
      class Upload < RawUpload
        def md5
          md5_digest.to_s
        end

        def add(_data)
          md5_digest.new.update(_data)
          super
        end

        private
        def md5_digest
          @md5_digest ||= Digest::MD5
        end
      end
    end
  end
end
