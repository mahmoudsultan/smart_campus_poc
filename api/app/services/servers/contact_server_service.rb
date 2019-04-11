# frozen_string_literal: true

require 'net/http'

module Servers
  class ContactServerService
    def initialize(params)
      @uri = URI(Rails.configuration.attendance_api.endpoint)
      @request_body = params[:request_body]
      @content_type = params[:content_type]
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
      res.body
    end
  end
end
