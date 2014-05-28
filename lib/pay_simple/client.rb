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
      if (self.error?)
        false
      else
        simple_object.hydrate(response)
      end
    end

    def fetch(simple_object)
      options = {
        headers: authentication_headers
      }
      response = parse_response(self.class.get simple_object_endpoint(simple_object) + "/#{simple_object.id}", options)
      if (self.error?)
        false
      else
        simple_object.hydrate(response)
      end
    end

    def parse_response(response)
      json = JSON.parse(response.body)
      @errors = json['Meta']['Errors']
      if @errors.nil?
        json['Response']
      else
        false
      end
    end

    def simple_object_endpoint(simple_object)
      endpoint = simple_object.class.name.split("::")[1..-1].join('/').downcase
      "/#{VERSION}/#{endpoint}"
    end
  end
end
