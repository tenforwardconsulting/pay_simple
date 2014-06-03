require 'httparty'

module PaySimple
  class Client
    VERSION = 'v4'
    include HTTParty
    debug_output $stderr
    # base_uri "https://api.paysimple.com"
    base_uri "https://sandbox-api.paysimple.com"

    attr_reader :errors
    # This server token changes for every request and is based on the current time
    # and the "shared secret" aka api_key
    def authentication_headers
      timestamp = Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
      signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha256'), PaySimple.api_key, timestamp))
      
      {
        'Authorization' => "PSSERVER accessid=#{PaySimple.api_user}; timestamp=#{timestamp}; signature=#{signature}",
        'Content-type' => 'application/json'
      }
    end

    def customer
      do_request "customer?lite=true"
    end

    def error?
      !!@errors
    end

    def error_messages
      message = @errors['ErrorCode'] + ": "
      message += @errors['ErrorMessages'].collect {|x| x['Message']}.join("; ")
    end

    def do_request(url)
      response = self.class.get "/#{VERSION}/#{url}", headers: authentication_headers
      puts response.body
    end

    def create(simple_object)
      options = {
        headers: authentication_headers,
        body: simple_object.to_json
      }
      response = parse_response(self.class.post simple_object_endpoint(simple_object), options)
      if (response)
        simple_object.hydrate(response)
      else
        raise "Could not create #{simple_object.class.name}: #{error_messages}"
      end
    end

    def fetch(simple_object)
      options = {
        headers: authentication_headers
      }
      response = parse_response(self.class.get simple_object_endpoint(simple_object) + "/#{simple_object.id}", options)
      if (response)
        simple_object.hydrate(response)
      else
        nil
      end
    end

    def fetch_association(simple_object, association)
      options = {
        headers: authentication_headers
      }
      association_info = simple_object.class.associations[association]
      endpoint = association_info[:endpoint]
      response = parse_response(self.class.get simple_object_endpoint(simple_object) + "/#{simple_object.id}/#{endpoint}", options)
      if (response)
        clazz = Kernel.qualified_const_get("PaySimple::#{association_info[:class_name]}")
        if (association_info[:multiple])
          raise "welp"
        else
          instance = clazz.new
          instance.hydrate(response)
        end
      else
        nil
      end
    end

    def parse_response(response)
      json = JSON.parse(response.body)
      @errors = json['Meta']['Errors']
      if @errors.nil?
        json['Response']
      else
        nil
      end
    end

    def simple_object_endpoint(simple_object)
      endpoint = simple_object.class.name.split("::")[1..-1].join('/').downcase
      "/#{VERSION}/#{endpoint}"
    end
  end
end
