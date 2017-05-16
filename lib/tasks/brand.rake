namespace :brand do
  	desc 'new brand'

  	task new: :environment do
  		name = "中山雅琪"
  		ident = "zsyq"
  		brand = Brand.new(name: name, identifier: ident)
  		brand.save if brand.valid?
  	end

end