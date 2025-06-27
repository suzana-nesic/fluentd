require 'uri'

module URI
  unless respond_to?(:unescape)
    def self.unescape(str)
      URI.decode_www_form_component(str)
    end
  end
end
