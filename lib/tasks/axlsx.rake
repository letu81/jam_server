require 'axlsx'
namespace :axlsx do
  	desc 'new excel'

  	namespace :new do
  		desc 'new brand'

	  	namespace :szjam do
			desc 'new kind'
		  	task kind: :environment do
		  		#p Kind.by_brand("深圳佳安美").map(&:name)
	            kind_name = "J-10"
		  		uuids = DeviceUuid.by_brand_and_kind("深圳佳安美", kind_name)
	            p = Axlsx::Package.new
				p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
				  	sheet.add_row ["厂家", "型号", "验证码", "校验码", "类别", "网址"]
				  	uuids.each do |uuid|
				  		#sheet.add_row [uuid.brand_name, uuid.kind_name, uuid.uuid, uuid.password, uuid.category_name, "www.jiaanmei.com"]
				  		sheet.add_row [uuid.brand_name, uuid.kind_name, "验证码:" + uuid.uuid, "校验码:" + uuid.password, uuid.category_name, "www.jiaanmei.com"]
					end
				end
				p.use_shared_strings = true
				p.serialize("public/docs/#{kind_name}.xlsx")
		  	end
	  	end

	  	namespace :zsyq do
			desc 'new kind'
		  	task kind: :environment do
		  		#p Kind.by_brand("中山雅麒").map(&:name)
	            kind_name = "JZMG86"
		  		uuids = DeviceUuid.by_brand_and_kind("中山雅麒", kind_name)
	            p = Axlsx::Package.new
				p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
				  	sheet.add_row ["厂家", "型号", "验证码", "校验码", "类别", "网址"]
				  	uuids.each do |uuid|
				  		#sheet.add_row [uuid.brand_name, uuid.kind_name, uuid.uuid, uuid.password, uuid.category_name, "www.jiaanmei.com"]
				  		sheet.add_row [uuid.brand_name, uuid.kind_name, "验证码:" + uuid.uuid, "校验码:" + uuid.password, uuid.category_name, "www.jiaanmei.com"]
					end
				end
				p.use_shared_strings = true
				p.serialize("public/docs/#{kind_name}.xlsx")
		  	end
	  	end
  	end

end