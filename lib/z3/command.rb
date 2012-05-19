require 'base64'

module Z3
  class Command

    def initialize(env, options={})
      @env=env
      @logger=options[:logger]
      @request= ::Rack::Request.new(env)
    end

    attr_reader :options

    def self.name(_name=nil)
      if _name
        @name=_name
      else
        @name ||= Z3::Utils.class_to_underscore(self)
      end
    end

    def name
      self.class.name
    end

    def to_s
      s="#{name}: #{bucket_name} / #{object_name} ? #{resource}\n"
      amz.each do |k, v|
        s << "x-amz-#{k} = '#{v}'\n"
      end
      s
    end

    def bucket_name
      env["z3.bucket_name"]
    end

    def object_name
      env["z3.object_name"]
    end

    def resource
      env["z3.resource"]
    end

    def path_info
      env["z3.path_info"]
    end


    #all http headers starting with 'x-amz-'
    def amz(key=nil)
      extract_amz
      key ? @amz[key] : @amz
    end

    #all http headers starting with 'x-amz-meta-'
    def meta(key=nil)
      extract_amz
      key ? @meta[key] : @meta
    end

    def access_key
      extract_access_key_signature
      env["z3.access_key"]
    end

    def signature
      extract_access_key_signature
      @signature
    end

    #true if parts of the query string are used for authentication
    #see: http://docs.amazonwebservices.com/AmazonS3/latest/dev/RESTAuthentication.html
    def query_string_request_authentication?
      extract_access_key_signature
      @query_string_auth
    end

    def expires_at_i
      extract_access_key_signature
      @expires_at_i
    end

    def expires_at
      Time.at(expires_at_i) if expires_at_i
    end

    def timestamp
      return @timestamp if defined?(@timestamp)
      @timestamp = DateTime.parse(amz['date'] || env['HTTP_DATE']) rescue nil
    end

    def calculated_signature(key)
      hmac_sha1(key, string_to_sign)
    end

    def valid_signature?(key)
      #http://docs.amazonwebservices.com/AmazonS3/latest/dev/RESTAuthentication.html
      #x-amz-date must be present and within 15 minutes else fail with RequestTimeTooSkewed
      calculated_signature(key) == signature
    end

    def valid_time?(now=DateTime.now)
      if query_string_request_authentication?
        expires_at>now
      else
        if timestamp
          timestamp >= (now - Z3::MINUTES15) && timestamp <= (now + Z3::MINUTES15)
        else
          false
        end
      end
    end

    def content_type
      env["CONTENT_TYPE"]
    end

    def string_to_sign
      return @string_to_sign if defined?(@string_to_sign)
      date_to_sign=query_string_request_authentication? ? expires_at_i : (amz["date"] ? '' : env['HTTP_DATE'])
      canonical = [env['REQUEST_METHOD'], env['HTTP_CONTENT_MD5'], env['CONTENT_TYPE'],
                   date_to_sign, path_info] # expires_at has to be signed! if query_string_auth? !!!
      amz.sort.each do |k, v|
        canonical[-1, 0] = "x-amz-#{k}:#{v}"
      end
      @string_to_sign = canonical.map { |v| v.to_s.strip } * "\n"
    end


    def execute
      command
    end

    def self.with_xml
      @with_xml=true
    end

    def self.with_xml?
      !!@with_xml
    end


    def with_xml?
      self.class.with_xml?
    end

    def self.with_data
      @with_data=true
    end

    def self.with_data?
      !!@with_data
    end

    def with_data?
      self.class.with_data?
    end


    def upload
      env["z3.upload"]
    end

    def upload=(obj)
      env["z3.upload"] = obj
    end

    def xml
      env["z3.xml"]
    end

    def xml=(obj)
      env["z3.xml"] = obj
    end

    private

    attr_reader :request, :logger, :env

    def command
      raise "implement execute on #{name}"
    end

    def render_no_content(headers={}, code=200)
      [code, headers, ""]
    end

    def add_meta(metas)
      headers={}
      if metas && !metas.empty?
        metas.each do |k, v|
          k_name="x-amz-meta-#{k}"
          headers[k_name]=v
        end
      end
      headers
    end

    def to_time(_time)
      _time.httpdate
    end

    def params
      request.params
    end

    def hmac_sha1(key, s)
      # TBD: check for speed
      #digest=OpenSSL::Digest::Digest.new("sha1")
      #return Base64.encode64(OpenSSL::HMAC.digest(digest, key, s)).strip

      ipad = [].fill(0x36, 0, 64)
      opad = [].fill(0x5C, 0, 64)
      key = key.unpack("C*")
      if key.length < 64 then
        key += [].fill(0, 0, 64-key.length)
      end

      inner = []
      64.times { |i| inner.push(key[i] ^ ipad[i]) }
      inner += s.unpack("C*")

      outer = []
      64.times { |i| outer.push(key[i] ^ opad[i]) }
      outer = outer.pack("c*")
      outer += Digest::SHA1.digest(inner.pack("c*"))

      return Base64::encode64(Digest::SHA1.digest(outer)).chomp
    end

    def extract_amz
      return if @amz
      @amz={}
      @meta={}

      @env.each do |k, v|
        if k =~ /^HTTP_X_AMZ_([_\w]+)$/
          key = $1.downcase.gsub('_', '-')
          @amz[key] = v.strip
          @meta[$1] = v if key =~ /^meta-([_\w]+)$/
        end
      end
      nil
    end

    def extract_access_key_signature
      return if  @signature
      auth, key_s, secret_s = *@env['HTTP_AUTHORIZATION'].to_s.match(/^AWS (\w+):(.+)$/)

      #support get params
      if request.params["Signature"] && request.params["AWSAccessKeyId"]
        key_s, secret_s, date_s = request.params["AWSAccessKeyId"],
            request.params["Signature"], request.params["Expires"]
        @query_string_auth=true
        @expires_at_i=date_s.to_i
      else
        @query_string_auth=false
      end

      env["z3.access_key"] ||= key_s #you can override it
      @signature=secret_s
    end


  end
end