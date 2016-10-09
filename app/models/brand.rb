class Brand < ActiveRecord::Base
	validates :name, :uniqueness => true

	has_many :kinks
end