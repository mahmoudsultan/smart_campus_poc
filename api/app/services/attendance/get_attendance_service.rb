# frozen_string_literal: true

require 'json'

module Attendance
  class GetAttendanceService
    def initialize(params)
      # Request should be a JSON object containing the image and some metadata
      # which will be used by the server to determine which students it should
      # compare against.
      # For now the server expects the request to be just the image.

      @image = params[:image]
      @class_info = params[:info]
      @content_type = 'image/jpeg'
    end

    def execute
      call
    end

    private

    def call
      params = { request_body: build_request_body, content_type: @content_type }
      ContactServerService.new(params).execute
    end

    # TODO: Refactor to add class students ids
    def build_request_body
      @image
    end
  end
end
