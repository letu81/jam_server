require 'chinese_pinyin'
require 'json'
namespace :regions do
  desc 'insert areas.json to db'

  desc 'insert areas.json to db'
  task :insert_data => :environment do
    CHINA = '000000' # 全国
    PATTERN = /(\d{2})(\d{2})(\d{2})/

    json = JSON.parse(File.read("#{Rails.root}/config/areas.json"))

        @list = {}
        #@see: https://github.com/cn/GB2260
        streets = json.values.flatten
        streets.each do |street|
          id = street['id']
          text = street['text']
          sensitive_areas = street['sensitive_areas'] || false
          if id.size == 6    # 省市区
            if id.end_with?('0000')    
              @list[id] =  {:text => text, :sensitive_areas => sensitive_areas, :children => {}}                       # 省
              new_privince = District.new(code: id, sensitive_areas: sensitive_areas, name:text, 
                pinyin: Pinyin.t(text, splitter: ''), abbr: Pinyin.t(text) { |letters| letters[0].upcase },
                level: 1)
              new_privince.save if new_privince.valid?
            elsif id.end_with?('00')                          # 市
              province_id = province(id)
              @list[province_id] = {:text => nil, :children => {}} unless @list.has_key?(province_id)
              @list[province_id][:children][id] = {:text => text, :sensitive_areas => sensitive_areas, :children => {}}
              new_city = District.new(code: id, parent_code: province_id, sensitive_areas: sensitive_areas, name:text, 
                pinyin: Pinyin.t(text, splitter: ''), abbr: Pinyin.t(text) { |letters| letters[0].upcase },
                level: 2)
              new_city.save if new_city.valid?
            else
              province_id = province(id)
              city_id     = city(id)
              @list[province_id] = {:text => text, :sensitive_areas => sensitive_areas, :children => {}} unless @list.has_key?(province_id)
              @list[province_id][:children][city_id] = {:text => text, :sensitive_areas => sensitive_areas, :children => {}} unless @list[province_id][:children].has_key?(city_id)
              @list[province_id][:children][city_id][:children][id] = {:text => text, :sensitive_areas => sensitive_areas, :children => {}}
              new_district = District.new(code: id, parent_code: city_id, sensitive_areas: sensitive_areas, name:text, 
                pinyin: Pinyin.t(text, splitter: ''), abbr: Pinyin.t(text) { |letters| letters[0].upcase },
                level: 3)
              new_district.save if new_district.valid?
            end
          else               # 街道
            province_id = province(id)
            city_id     = city(id)
            district_id = district(id)
            @list[province_id] = {:text => text, :sensitive_areas => sensitive_areas, :children => {}} unless @list.has_key?(province_id)
            @list[province_id][:children][city_id] = {:text => text, :sensitive_areas => sensitive_areas, :children => {}} unless @list[province_id][:children].has_key?(city_id)
            @list[province_id][:children][city_id][:children][district_id] = {:text => text, :sensitive_areas => sensitive_areas, :children => {}} unless @list[province_id][:children][city_id][:children].has_key?(district_id)
            @list[province_id][:children][city_id][:children][district_id][:children][id] = {:text => text, :sensitive_areas => sensitive_areas}
            new_street = District.new(code: id, parent_code: district_id, sensitive_areas: sensitive_areas, name:text, 
                pinyin: Pinyin.t(text, splitter: ''), abbr: Pinyin.t(text) { |letters| letters[0].upcase },
                level: 4)
            new_street.save if new_street.valid?
          end
        end
  end

  def province(code)
    match(code)[1].ljust(6, '0')
  end

  def city(code)
    id_match = match(code)
    "#{id_match[1]}#{id_match[2]}".ljust(6, '0')
  end

  def district(code)
    code[0..5].rjust(6,'0')
  end

  def match(code)
    code.match(PATTERN)
  end

end