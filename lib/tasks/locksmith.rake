require 'chinese_pinyin'
require 'json'
require 'nokogiri'
namespace :locksmith do

  desc 'insert locksmiths to db'
  task :insert_data => :environment do
    city_url = "http://www.zhaosuojiang.com/list.php?fid=73&city_id=6"
    time_start = Time.now
    p Time.now.strftime("%Y-%m-%d-%H-%M-%S")

    begin
            doc_city = Nokogiri::HTML(open(city_url))
            return if doc_city.css('div.zone span.choose a').empty?
            doc_city.css('div.zone span.choose a').each do |link|
                next if link.text == "市辖区"
                p link.text
                district_pinyin = Pinyin.t(link.text, splitter: '')
                doc_district = Nokogiri::HTML(open(link['href']))
                return if doc_district.css('div.ShowList div.date').empty?

                doc_district.css('div.ShowList div.date').each do |div|
                    next if div.text.include?("备")
                    return if div.previous_element.css('div.t a').empty?
                    doc_user = Nokogiri::HTML(open(div.previous_element.css('div.t a')[0]['href']))
                    return if doc_user.css('table.leftinfo td.base div.baseinfo span').empty?

                    res ||= {'company_info' => '', 'company_service' => '', 'logo' => ''}
                    doc_user.css('table.leftinfo td.base a img').each do |img|
                        res['logo'] = img['src'] if img['src'].include?('logo')
                    end

                    doc_user.css('table.leftinfo td.base div.baseinfo span').each do |span|
                        k,v = span.text.strip.split(/：/)
                        next if k.nil? 
                        res[k] = v.nil? ? "" : v.strip
                    end

                    doc_user.css('table.leftinfo tr').each do |tr|
                        item = tr.css('span.T')
                        if item.text == '联系方式'
                            tr.next_element.css('td.content').each do |td|
                                next if td.text.strip.length == 0
                                td.text.strip.split(/\n/).each do |text|
                                    k,v = text.strip.split(/：/)
                                    next if k.nil? || v.nil?
                                    res[k] = v.nil? ? "" : v.strip
                                end
                            end
                        end
                    end

                    doc_user.css('table.rightinfo tr').each do |tr|
                        item = tr.css('span.T')
                        next if item.empty?
                        case item.text
                        when '公司简介'
                            tr.next_element.css('td.content span').each do |span|
                                next if span.text.strip.length == 0
                                res['company_info'] << span.text.strip + "\n"
                            end
                        when '服务项目'
                            tr.next_element.css('td.content span').each do |span|
                                next if span.text.strip.length == 0
                                res['company_service'] << span.text.strip + "\n"
                            end
                        else
                        end
                    end

                    p "=======vvvv========"
                    p res
                    p "=======vvvv========"

                    service_district = District.where(pinyin: district_pinyin).first
                    if service_district
                      new_locksmith = Locksmith.new(name: res['姓名'], mobile: res['联系手机'],
                        avatar: '', is_verified: true, address: "深圳市" + service_district.name, 
                        phone: res['联系电话'].nil? ? "" : res['联系电话'], district_code: service_district.code,
                        certificate_number: res['备案号'], qq: res['客服1 QQ'].nil? ? "" : res['客服1 QQ'],
                        company_info: res['company_info'], company_service: res['company_service'])
                      if new_locksmith.valid? && new_locksmith.save
                        next if res['logo'].length == 0
                        ZhaosuojiangPictureJob.set(queue: "locksmith_update_avatar").perform_later(new_locksmith, res['logo'])
                      end
                    end
                end

                sleep(rand(20))
            end
    rescue Exception => e
      p e.message
    end

    time_end = Time.now
    p "执行完毕！耗时#{ time_end - time_start }秒"
  end
end