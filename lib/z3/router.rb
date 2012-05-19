module Z3
  #this class analyses the request and extracts bucket name, method, object name and resource
  #these things are needed for to identify the command that should be run.
  #

  class Router
    #the default tld so if you have a request to xxx.zzz.com zzz.com will be ignored and xxx if the bucket name
    DEFAULTS={:tld => 1, :resources => Z3::RESOURCES, :command_map => Z3::COMMAND_MAP}

    #options can have
    # :tld
    # resources
    def initialize(_env, options={})
      @env=_env
      @options= DEFAULTS.merge(options)
      @request= ::Rack::Request.new(_env)
    end

    attr_reader :options

    #subdomain or empty string
    def subdomain
      return env["z3.subdomain"] if env.has_key?("z3.subdomain")
      _sub= extract_subdomains(options[:tld]).join('.')
      env["z3.subdomain"] = _sub.empty? ? nil : _sub
    end

    #was a subdomain given?
    def subdomain?
      !subdomain.nil?
    end

    #the requestet bucket if any
    def bucket_name
      return env["z3.bucket_name"] if env.has_key?("z3.bucket_name")
      path_info.match(/^\/([^\/]*)/)
      env["z3.bucket_name"]= $1.empty? ? nil : $1
    end

    #the object's name (key) without the bucket
    def object_name
      return env["z3.object_name"] if env.has_key?("z3.object_name")
      path_info.match(/^\/([^\/])+\/([^\?]*)/)
      name=$2
      name=CGI.unescape(name) if name
      name = nil if name && name.empty?
      env["z3.object_name"]=name
    end

    #resource (like 'acl', 'location') if given else nil
    def resource
      return env["z3.resource"] if env.has_key?("z3.resource")
      env["z3.resource"] = (request.params.keys & resources).first
    end

    #is a resource given?
    def resource?
      !!resource
    end

    def method
      env["REQUEST_METHOD"]
    end

    # bucket name + object_name + ('?' + resource)
    # the path to be signed
    def path_info
      return env["z3.path_info"] if env.has_key?("z3.path_info")
      _path=request.path_info
      if subdomain?
        env["z3.path_info"]= "/#{subdomain}#{_path}"
      else
        env["z3.path_info"]= _path
      end
      env["z3.path_info"] += "?#{resource}" if resource?
      env["z3.path_info"]
    end

    #what's the command that should be run?
    def command_name
      case
        when bucket_name && object_name
          case method
            when 'GET'
              'get_object'
            when 'PUT'
              'put_object'
            when 'DELETE'
              'delete_object'
            when 'HEAD'
              'head_object'
          end
        when bucket_name && !object_name
          case method
            when 'GET'
              case resource
                when 'location'
                  'get_bucket_location'
                when nil
                  'get_bucket'
              end
            when 'PUT'
              'put_bucket'
            when 'DELETE'
              'delete_bucket'
            when 'HEAD'
              'head_bucket'
          end
        when !bucket_name && !object_name && method == "GET"
          'get_service'
        else
          extended_command_name
      end
    end

    #return [Z3::Command] the class of the command that should be run
    def command
      options[:command_map][command_name]
    end

    private
    attr_reader :env, :request

    #you should override this if you need more commands
    def extended_command_name
      nil
    end

    #resources we check for
    def resources
      options[:resources]
    end

    #taken from Rails 3.2.2
    def raw_host_with_port
      if forwarded = env["HTTP_X_FORWARDED_HOST"]
        forwarded.split(/,\s?/).last
      else
        env['HTTP_HOST'] || "#{env['SERVER_NAME'] || env['SERVER_ADDR']}:#{env['SERVER_PORT']}"
      end
    end

    def host
      raw_host_with_port.sub(/:\d+$/, '')
    end

    def named_host?(host)
      !(host.nil? || /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/.match(host))
    end

    def extract_subdomains(tld_length = 1)
      return [] unless named_host?(host)
      parts = host.split('.')
      parts[0..-(tld_length+2)]
    end

  end
end