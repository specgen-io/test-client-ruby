require "net/http"
require "net/https"
require "uri"
require "emery"

module TestService
  class EchoClient < BaseClient
    def echo_body(body:)
      url = @base_uri + '/echo/body'
      request = Net::HTTP::Post.new(url)
      body_json = Jsoner.to_json(Message, T.check_var('body', Message, body))
      request.body = body_json
      response = @client.request(request)
      case response.code
      when '200'
        Jsoner.from_json(Message, response.body)
      else
        raise StandardError.new("Unexpected HTTP response code #{response.code}")
      end
    end
    
    def echo_query(int_query:, string_query:)
      query = StringParams.new
      query.set('int_query', Integer, int_query)
      query.set('string_query', String, string_query)
      url = @base_uri + '/echo/query' + query.query_str
      request = Net::HTTP::Get.new(url)
      response = @client.request(request)
      case response.code
      when '200'
        Jsoner.from_json(Message, response.body)
      else
        raise StandardError.new("Unexpected HTTP response code #{response.code}")
      end
    end
    
    def echo_header(int_header:, string_header:)
      header = StringParams.new
      header.set('Int-Header', Integer, int_header)
      header.set('String-Header', String, string_header)
      url = @base_uri + '/echo/header'
      request = Net::HTTP::Get.new(url)
      header.params.each { |name, value| request.add_field(name, value) }
      response = @client.request(request)
      case response.code
      when '200'
        Jsoner.from_json(Message, response.body)
      else
        raise StandardError.new("Unexpected HTTP response code #{response.code}")
      end
    end
    
    def echo_url_params(int_url:, string_url:)
      url_params = StringParams.new
      url_params.set('int_url', Integer, int_url)
      url_params.set('string_url', String, string_url)
      url = @base_uri + url_params.set_to_url('/echo/url_params/{int_url}/{string_url}')
      request = Net::HTTP::Get.new(url)
      response = @client.request(request)
      case response.code
      when '200'
        Jsoner.from_json(Message, response.body)
      else
        raise StandardError.new("Unexpected HTTP response code #{response.code}")
      end
    end
    
  end
  
  class CheckClient < BaseClient
    def check_query(p_string:, p_string_opt:, p_string_array:, p_date:, p_date_array:, p_datetime:, p_int:, p_long:, p_decimal:, p_enum:, p_string_defaulted: 'the default value')
      query = StringParams.new
      query.set('p_string', String, p_string)
      query.set('p_string_opt', T.nilable(String), p_string_opt)
      query.set('p_string_array', T.array(String), p_string_array)
      query.set('p_date', Date, p_date)
      query.set('p_date_array', T.array(Date), p_date_array)
      query.set('p_datetime', DateTime, p_datetime)
      query.set('p_int', Integer, p_int)
      query.set('p_long', Integer, p_long)
      query.set('p_decimal', Float, p_decimal)
      query.set('p_enum', Choice, p_enum)
      query.set('p_string_defaulted', String, p_string_defaulted)
      url = @base_uri + '/check/query' + query.query_str
      request = Net::HTTP::Get.new(url)
      response = @client.request(request)
      case response.code
      when '200'
        nil
      else
        raise StandardError.new("Unexpected HTTP response code #{response.code}")
      end
    end
    
  end
  
  class TestServiceClient
    attr_reader :echo_client
    attr_reader :check_client
    def initialize(base_url)
      @echo_client = EchoClient.new(base_url)
      @check_client = CheckClient.new(base_url)
    end
    
  end
end

