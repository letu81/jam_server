class Feedback < ActiveRecord::Base
  validates :content, length: { maximum: 1000, minimum: 3 }, presence: true
  validates :contact, length: { maximum: 20, minimum: 3 }, presence: true
end