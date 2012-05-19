module Z3
  class Response
    NAMESPACE = "http://s3.amazonaws.com/doc/2006-03-01/"

    def self.namespace
      NAMESPACE
    end

    private
    def self.build_xml
      xml = Builder::XmlMarkup.new
      xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
      yield xml
      xml.target!
    end
  end
end