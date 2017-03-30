require 'mini_magick'
require 'rest-client'
require 'json'
class YsCapturePictureJob < ActiveJob::Base
    queue_as :default

    def perform(*args)
        begin
            message = args[0]
            device = Device.where(device_id: message.device_id).first
            return if device.nil? || device.monitor_sn.nil? || device.monitor_sn.blank?
        	device_id = device.monitor_sn
    		max_time = 6
            succuessed = 0
            path = "public/pictures/lock/#{device_id}"
            Dir.mkdir(path) unless Dir.exist?(path)
            if Setting[:ez_access_token].blank?
            	ys_token_url = "https://open.ys7.com/api/lapp/token/get"
            	params = {appKey:Setting.ez_app_key, appSecret:Setting.ez_app_secret}
            	response = RestClient.post ys_token_url, params
                if response.code == 200
                    result = JSON.parse(response.body)
                    data = result['data']
                    Setting[:ez_access_token] = data['accessToken']
                else
                	p response.code 
                    p response.body
                end
            end

            params = {accessToken: Setting[:ez_access_token], deviceSerial: device_id, channelNo: 1, quality: 1}
            ys7_capture_url = "https://open.ys7.com/api/lapp/device/capture"
            tmp_gif_path = "#{path}/#{Time.now.strftime("%Y_%m_%d_%H_%M_%S")}.gif"
            tmp_avatar_path = ""
            tmp_picture_urls = { "ys7" => [] }
            tmp_picture_paths = []

            ## get capture picture from ys7
            i = 1
            while (i < max_time) do
                response = RestClient.post ys7_capture_url, params
                result = JSON.parse(response.body)
                p result

                if response.code == 200             
                    if result['code'].to_i == 200
                        succuessed += 1
                        data = result['data']
                        pic_url = data['picUrl']
                        tmp_picture_urls["ys7"] << pic_url
                        image = MiniMagick::Image.open(pic_url)
                        image.contrast
                        filename = "lock_#{i}.jpg"
                        tmp_picture_paths << "#{path}/#{filename}"
                        image.write("#{path}/#{filename}")
                        if i == 1
                            image.resize "128x72"
                            tmp_avatar_path = "#{path}/small_#{Time.now.strftime("%Y_%m_%d_%H_%M_%S")}.jpg"
                            image.write(tmp_avatar_path)
                        end
                    else
                        p result['code']
                        p result['msg']
                    end
                else
                    p response.code
                    p response.body
                    p result['msg']
                end
                i = i + 1
                sleep 5
            end
            if succuessed > 0
                ## onvert gif
                system 'convert -delay 100 -loop 3 ' + path + '/lock_*.jpg ' + tmp_gif_path
                ## delete temp file
                tmp_picture_paths.each do |file_path|
                    File.delete(file_path) if File.exist?(file_path)
                end
                ## write db avatar_url gif_url ori_picture_urls
                message.update_attributes({avatar_path: tmp_avatar_path.gsub("public/", ""), gif_path: tmp_gif_path.gsub("public/", ""), ori_picture_urls: tmp_picture_urls}) 
            end
        rescue Exception => e
            p "YsCapturePictureJob error...."
            p e.message
        end
    end
end