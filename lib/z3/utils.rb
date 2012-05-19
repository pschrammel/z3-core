module Z3
  module Utils
    def self.to_underscore(str)
      str.gsub(/(.)([A-Z])/, '\1_\2').downcase
    end

    def self.class_to_underscore(klass)
      to_underscore(klass.to_s.split('::').last)
    end

    #map class name to method name
    def self.map_commands(*commands)
      Hash[*(commands.flatten.map { |cmd| [cmd.name, cmd] }.flatten)]
    end
  end
end