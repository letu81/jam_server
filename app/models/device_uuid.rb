class DeviceUuid < ActiveRecord::Base
    STATUSES = {:not_use => 1, :used => 2, :discard => 3}

    belongs_to :device_category, :foreign_key => 'device_category_id'
    belongs_to :device
    belongs_to :kind, :foreign_key => 'kind_id'

	validates :uuid, :uniqueness => true

    def self.new_uuid
    	uuid = SecureRandom.hex[0..7]
    	pwd = SecureRandom.hex[0..3]
    	kind = Kind.first
    	if kind
    		device_uuid = self.new(uuid: uuid, password: pwd, kind_id: kind.id)
    		device_uuid.save! if device_uuid.valid?
    	else
    		device_uuid = self.new(uuid: uuid, password: pwd)
    		device_uuid.save! if device_uuid.valid?
    	end
    end

    def self.by_user(user_id)
        self.joins("INNER JOIN devices ON device_uuids.id=devices.uuid
                    INNER JOIN user_devices ON user_devices.device_id=devices.id")
        .where("user_devices.user_id = ?", user_id)
        .select("devices.brand_id as id")
        .group("devices.brand_id")
    end

    def self.new_uuid_by_kind_and_category(kind_id, category_id)
        uuid = SecureRandom.hex[0..7]
        pwd = SecureRandom.hex[0..3]
        device_uuid = self.new(uuid: uuid, password: pwd, kind_id: kind_id, device_category_id: category_id)
        device_uuid.save! if device_uuid.valid?
    end

    def self.by_brand(brand_ident)
        self.joins("INNER JOIN kinds ON device_uuids.kind_id = kinds.id 
                    INNER JOIN brands ON brands.id = kinds.brand_id
                    INNER JOIN device_categories ON device_categories.id = device_uuids.device_category_id")
        .where("brands.identifier = ? and device_uuids.status_id = ?", brand_ident, STATUSES[:not_use])
        .select("brands.name as brand_name, kinds.name as kind_name, 
                 device_categories.name as category_name, device_uuids.uuid, device_uuids.password, device_uuids.password, device_uuids.device_mac")
    end

    def self.by_brand_and_kind(brand_ident, kind_name)
        self.joins("INNER JOIN kinds ON device_uuids.kind_id = kinds.id 
                    INNER JOIN brands ON brands.id = kinds.brand_id
                    INNER JOIN device_categories ON device_categories.id = device_uuids.device_category_id")
        .where("brands.identifier = ? and kinds.name = ? and device_uuids.status_id = ? and DATE(device_uuids.created_at) = ?", brand_ident, kind_name, STATUSES[:not_use], Date.today)
        .select("brands.name as brand_name, kinds.name as kind_name, 
                 device_categories.name as category_name, device_uuids.uuid, device_uuids.password, device_uuids.device_mac")
    end
end