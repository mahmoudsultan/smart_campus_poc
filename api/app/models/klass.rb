# frozen_string_literal: true

class Klass < ApplicationRecord
  belongs_to :building
  has_one :klass_topic_map

  validates :name, :floor, :capacity, :building, presence: true

  def topic_name
    self.klass_topic_map.topic
  end
end
