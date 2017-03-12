class Brand < ActiveRecord::Base
	validates :name, :uniqueness => true

	NAMES = {:hzys7 => 2}

	has_many :kinks
end