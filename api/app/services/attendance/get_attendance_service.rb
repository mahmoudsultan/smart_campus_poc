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
      @student_ids = params[:ids]
      @content_type = 'application/json'
    end

    def execute
      call
    end

    private

    def call
      Servers::ContactServerService.new(uri, build_request_body, @content_type).execute
    end

    def uri
      URI(Rails.configuration.attendance_api)
    end

    def build_request_body
      req = {'image' => @image, 'ids' => @student_ids}
      req.to_json
    end
  end
end
