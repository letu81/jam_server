require 'chinese_pinyin'
class UpdateDistrictCodeJob < ActiveJob::Base
    queue_as :low_priority

    def perform(*args)
        begin
            user = args[0]
            province = args[1]
            city = args[2]
            district = args[3]
            if d_province = District.province.where(pinyin: Pinyin.t(province, splitter: '')).first
                if d_city = District.where(parent_code: d_province.code, pinyin: Pinyin.t(city, splitter: '')).first
                    if d_district = District.where(parent_code: d_city.code, pinyin: Pinyin.t(district, splitter: '')).first
                        user.update_attribute(:district_code, d_district.code)
                    end
                end
            end
        rescue Exception => e
            p "UpdateDistrictCodeJob error...."
            p e.message
        end
    end
end