class Address < ActiveRecord::Base

  validates :mobile, format: { with: /\A1[3|4|5|8][0-9]\d{4,8}\z/, message: "请输入11位正确手机号" }, length: { is: 11 },
            :presence => true
            
  belongs_to :user
  
  def as_json(opts = {})
    {
      id: self.id,
      name: self.name || "",
      mobile: self.mobile || "",
      address: self.address | "",
      region: self.region | "",
      is_default: self.is_default
    }
  end
end
