class DeviceUuid < ActiveRecord::Base
    STATUSES = {:not_use => 1, :used => 2, :discard => 3}

    belongs_to :device_category, :foreign_key => 'device_category_id'
    belongs_to :device

	validates :uuid, :uniqueness => true

    def self.new_uuid
    	uuid = (Digest::MD5.hexdigest "#{SecureRandom.urlsafe_base64(nil, false)}-#{Time.now.to_i}").first(8)
    	pwd = SecureRandom.urlsafe_base64(nil, false).downcase.first(4)
    	kind = Kind.first
    	if kind
    		device_uuid = self.new(uuid: uuid, password: pwd, kind_id: kind.id)
    		device_uuid.save! if device_uuid.valid?
    	else
    		device_uuid = self.new(uuid: uuid, password: pwd)
    		device_uuid.save! if device_uuid.valid?
    	end
    end
end