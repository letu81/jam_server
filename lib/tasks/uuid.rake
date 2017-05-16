namespace :uuid do
  	desc 'new uuids'

  	namespace :new do
  		desc 'new brand'

  		namespace :szjam do
			desc 'new kind'
		  	task kind: :environment do
		  		#p Kind.by_brand("中山雅麒").map(&:name)
	            kind_name = "J-10"
	            kind = Kind.where("name = ?", kind_name).first
	            return if kind.nil?

	            category = DeviceCategory.where("name = ?", DeviceCategory::NAMES[1]).first
		  		return if category.nil?
                
                i = 0
                while i < 5
		  			DeviceUuid.new_uuid_by_kind_and_category(kind.id, category.id)
		  			i = i + 1
		  		end
		  	end
	  	end

	  	namespace :zsyq do
			desc 'new kind'
		  	task kind: :environment do
		  		#p Kind.by_brand("中山雅麒").map(&:name)
	            kind_name = "JZMG86"
	            kind = Kind.where("name = ?", kind_name).first
	            return if kind.nil?

	            category = DeviceCategory.where("name = ?", DeviceCategory::NAMES[1]).first
		  		return if category.nil?
                
                i = 0
                while i < 10
		  			DeviceUuid.new_uuid_by_kind_and_category(kind.id, category.id)
		  			i = i + 1
		  		end
		  	end
	  	end

  	end

end