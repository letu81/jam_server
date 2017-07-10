class Kind < ActiveRecord::Base
	STATUSES = {:active => 1, :locked => 2}

	belongs_to :brand

	validates :name, :uniqueness => {scope: [:brand_id]}

	def self.by_brand(brand_name)
        self.joins("INNER JOIN brands ON brands.id = kinds.brand_id")
        .where("brands.name = ?", brand_name)
        .select("brands.name as brand_name, kinds.name")
    end
end