class Feedback < ActiveRecord::Base
  validates :content, length: { max: 1000, min: 3 }, presence: true
  validates :contact, length: { max: 20, min: 3 }, presence: true
end