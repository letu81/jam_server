class Kind < ActiveRecord::Base
	STATUSES = {:active => 1, :locked => 2}

	belongs_to :brand

	def self.by_brand(brand_name)
        self.joins("INNER JOIN brands ON brands.id = kinds.brand_id")
        .where("brands.name = ?", brand_name)
        .select("brands.name as brand_name, kinds.name")
    end
end