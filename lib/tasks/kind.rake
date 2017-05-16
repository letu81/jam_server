namespace :kind do
  	desc 'new kinds'

  	namespace :new do
  		desc 'new kind'

  		task szjam: :environment do
			brand = Brand.where("identifier = ?", "szjam").first
			return if brand.nil?
	        name = "J-10"
	        kind  = Kind.new({name: name, brand_id: brand.id})
	        kind.save if kind.valid?
	  	end

	  	task zsyq: :environment do
		  	brand = Brand.where("identifier = ?", "zsyq").first
			return if brand.nil?
	        name = "JZMG86"
	        kind  = Kind.new({name: name, brand_id: brand.id})
	        kind.save if kind.valid?
	  	end

  	end

end