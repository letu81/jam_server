class DeviceUuid < ActiveRecord::Base
    STATUSES = {:not_use => 1, :used => 2, :discard => 3}

    belongs_to :device_category, :foreign_key => 'device_category_id'
    belongs_to :device

	validates :uuid, :uniqueness => true

    def self.new_uuid
    	uuid = (Digest::MD5.hexdigest "#{SecureRandom.urlsafe_base64(nil, false)}-#{Time.now.to_i}").first(8)
    	pwd = SecureRandom.urlsafe_base64(nil, false).downcase.first(4)
        if pwd.include?("_") || pwd.include?("-")
            pwd = SecureRandom.urlsafe_base64(nil, false).downcase.first(4)
        end
    	kind = Kind.first
    	if kind
    		device_uuid = self.new(uuid: uuid, password: pwd, kind_id: kind.id)
    		device_uuid.save! if device_uuid.valid?
    	else
    		device_uuid = self.new(uuid: uuid, password: pwd)
    		device_uuid.save! if device_uuid.valid?
    	end
    end

    def self.new_uuid_by_kind_and_category(kind_id, category_id)
        uuid = (Digest::MD5.hexdigest "#{SecureRandom.urlsafe_base64(nil, false)}-#{Time.now.to_i}").first(8)
        pwd = SecureRandom.urlsafe_base64(nil, false).downcase.first(4)
        if pwd.include?("_") || pwd.include?("-")
            pwd = SecureRandom.urlsafe_base64(nil, false).downcase.first(4)
        end

        device_uuid = self.new(uuid: uuid, password: pwd, kind_id: kind_id, device_category_id: category_id)
        device_uuid.save! if device_uuid.valid?
    end

    def self.by_brand(brand_name)
        self.joins("INNER JOIN kinds ON device_uuids.kind_id = kinds.id 
                    INNER JOIN brands ON brands.id = kinds.brand_id
                    INNER JOIN device_categories ON device_categories.id = device_uuids.device_category_id")
        .where("brands.name = ? and device_uuids.status_id = ?", brand_name, STATUSES[:not_use])
        .select("brands.name as brand_name, kinds.name as kind_name, 
                 device_categories.name as category_name, device_uuids.uuid, device_uuids.password")
    end

    def self.by_brand_and_kind(brand_name, kind_name)
        self.joins("INNER JOIN kinds ON device_uuids.kind_id = kinds.id 
                    INNER JOIN brands ON brands.id = kinds.brand_id
                    INNER JOIN device_categories ON device_categories.id = device_uuids.device_category_id")
        .where("brands.name = ? and kinds.name = ? and device_uuids.status_id = ?", brand_name, kind_name, STATUSES[:not_use])
        .select("brands.name as brand_name, kinds.name as kind_name, 
                 device_categories.name as category_name, device_uuids.uuid, device_uuids.password")
    end
end