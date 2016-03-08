class Todo < ActiveRecord::Base
  belongs_to :travel
  belongs_to :user

  validates :detail, presence: true, length: { maximum: 255 }

  class << self
    def build(params, user, travel_id)
      todo = new(params)
      todo.user_id = user.id
      todo.travel_id = travel_id
      todo
    end
  end
end
