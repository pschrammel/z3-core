module Z3
  class Error < StandardError
    def self.raise_error(*args)
      raise new(*args)
    end

    def initialize(resource)
      @resource=resource
    end

    attr_accessor :resource

    def to_xml
      _xml = Builder::XmlMarkup.new
      _xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"

      _xml.Error do |x|
        x.Code code
        x.Message message
        x.Resource resource
        x.RequestId 'not_implemented'
        x.HostId 'not_implemented'
      end
      _xml.target!
    end


    def code
      self.class.name.split('::').last
    end

    def http_status_code
      abstract(method)
    end

    def message
      abstract(method)
    end

    private
    def abstract(method)
      raise "You have to implement #{method}"
    end
  end
end