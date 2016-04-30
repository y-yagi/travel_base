class Event < ApplicationRecord
  include Recorder

  belongs_to :user
  belongs_to :place

  validates :name, presence: true, length: { maximum: 255 }
  validates :detail, length: { maximum: 1024 }

  after_destroy :record_deleted_datum

  paginates_per 10

  class << self
    def build(params, user)
      event = new(params)
      event.user = user
      event
    end
  end
end
