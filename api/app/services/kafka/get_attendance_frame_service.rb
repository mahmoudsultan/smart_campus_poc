module Kafka
    class GetAttendanceFrameService
      def initialize(topic_name)
        @topic_name = topic_name
      end
  
      # TODO return a single frame in base64 encoding
      def execute
        @frames = Kafka::GetFrameService(@topic_name)

        @frames
      end
    end
  end