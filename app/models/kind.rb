class Kind < ActiveRecord::Base
	STATUSES = {:active => 1, :locked => 2}

	belongs_to :brand
end