require 'kafka'

module Kafka
  SERVERS_ENDPOINTS = ["localhost:9092"]
  SERVER = Kafka.new(SERVERS_ENDPOINTS)

  def self.server
    SERVER
  end
end
