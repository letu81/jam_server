# coding: utf-8
require 'base64'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:mobile]
  validates :mobile, presence: true
  validates :mobile, format: { with: /\A1[3|4|5|8][0-9]\d{4,8}\z/, message: "请输入11位正确手机号" }, length: { is: 11 }, 
            :uniqueness => true
  
  has_many  :addresses

  before_create :update_private_token

  def update_private_token
    expired_at = 1.month.from_now
    token = (Digest::MD5.hexdigest "#{SecureRandom.urlsafe_base64(nil, false)}-#{self.id}-#{Time.now.to_i}")
    self.private_token = token
  end

  def hack_mobile
    return "" if self.mobile.blank?
    hack_mobile = String.new(self.mobile)
    hack_mobile[3..6] = "****"
    hack_mobile
  end

  def deliver_info
    Address.where(user_id: self.id, is_default: true).first
  end
end
