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
      endpoint = simple_object.class.name.split("::").last.downcase
      parse_response(self.class.post "/#{VERSION}/#{endpoint}", headers: authentication_headers, body: simple_object.to_json)
    end

    def parse_response(response)
      json = JSON.parse(response.body)
      @errors = json['Meta']['Errors']
      if @errors.ni?
        json['Response']
      else
        false
      end
    end
  end
end
