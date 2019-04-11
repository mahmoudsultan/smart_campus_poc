module Kafka
  class GetFrameService
    def initialize(topic_name)
      @topic_name = topic_name
    end

    def execute
      consumer = Kafka.server.consumer(group_id: 'demo')
      consumer.subscribe(@topic_name, start_from_beginning: false)
      
      consumer.each_message do |message|
        return message.value
      end
    end
  end
end
