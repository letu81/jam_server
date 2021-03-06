class Locksmith < ActiveRecord::Base
  
  validates :mobile, presence: true
  validates :mobile, format: { with: /\A1[3|4|5|8][0-9]\d{4,8}\z/, message: "请输入11位正确手机号" }, length: { is: 11 }, 
            :uniqueness => true

  scope :verified, lambda { where(is_verified: true) }
  scope :district, lambda { |district_code| where(district_code: district_code) }
end