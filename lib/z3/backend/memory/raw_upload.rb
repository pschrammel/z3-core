module Z3
  module Backend
    class Memory
      class RawUpload
        TEMPDIR='/tmp'

        def initialize
          @data=''
          @size=0
          @pieces = 0
        end

        attr_reader :size, :data


        def add(_data)
          @data << _data
          #statistics:
          @pieces += 1
          @started_at ||= Time.now
          @size +=_data.size
          nil
        end

        def started?
          !!@started_at
        end

        def speed
          return 0 unless started?
          @size/(Time.now-@started_at) #bytes/second
        end
      end
    end
  end
end
