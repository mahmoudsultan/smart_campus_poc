# frozen_string_literal: true

module Kafka
  class GetAttendanceFrameService
    def initialize(topic_name)
      @topic_name = topic_name
    end

    # TODO: return a single frame
    def execute
      @frames = Kafka::GetFrameService.new(@topic_name).execute
      @frames
    end
  end
end
