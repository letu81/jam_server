require 'mini_magick'
class ZhaosuojiangPictureJob < ActiveJob::Base
    queue_as :low_priority

    def perform(*args)
        begin
            locksmith = args[0]
            pic_url = args[1]

            path = "public/pictures/locksmiths/#{locksmith.id}"
            Dir.mkdir(path) unless Dir.exist?(path)
            
            image = MiniMagick::Image.open(pic_url)
            image.contrast
            image.resize "100x100"
            tmp_avatar_path = "#{path}/#{Time.now.strftime("%Y_%m_%d_%H_%M_%S")}.jpg"
            image.write(tmp_avatar_path)

            locksmith.update_attribute(:avatar, tmp_avatar_path.gsub("public/", "")) 
        rescue Exception => e
            p "ZhaosuojiangPictureJob error...."
            p e.message
        end
    end
end