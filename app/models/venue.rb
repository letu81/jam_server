class Venue < ActiveRecord::Base
  has_many :events

  self.primary_key = 'venue_id'

end
