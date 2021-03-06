# frozen_string_literal: true

require 'kafka'

module Kafka
  SERVERS_ENDPOINTS = ['kafka:9092'].freeze
  SERVER = Kafka.new(SERVERS_ENDPOINTS)

  def self.server
    SERVER
  end
end
