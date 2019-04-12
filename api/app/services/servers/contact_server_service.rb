# frozen_string_literal: true

require 'net/http'

module Servers
  class ContactServerService
    def initialize(uri, request_body, content_type)
      @uri = uri
      @request_body = request_body
      @content_type = content_type
    end

    def execute
      call
    end

    private

    def call
      http = Net::HTTP.new(@uri.host, @uri.port)
      req = Net::HTTP::Post.new(@uri.path, 'Content-Type' => @content_type)
      req.body = @request_body
      res = http.request(req)
      res
    end
  end
end
