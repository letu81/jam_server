class Brand < ActiveRecord::Base
	validates :name, :uniqueness => true

	NAMES = {:hzys7 => 3}
	STATUSES = {:active => 1, :not_public => 2, :locked => 3}

	has_many :kinks

	def self.by_ids(ids)
		self.joins("INNER JOIN brands ON kinds.brand_id = brands.id")
		.where("brands.status_id = ? AND brands.id IN (?)", STATUSES[:active], ids)
		.select("brands.id, kinds.name")
	end
end