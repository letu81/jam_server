# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
if true
user = User.create!(username: 'tutu', email: 'tutu@123456', mobile: '15712002798', password: '123456', password_confirmation: '123456')
DeviceCategory.create!(name: '门锁') 
DeviceCategory.create!(name: '网关')
DeviceCategory.create!(name: '插座')
DeviceCategory.create!(name: '门磁')
DeviceCategory.create!(name: '窗帘')
DeviceCategory.create!(name: '监控')
Brand.create!(name: '深圳佳安美', identifier: 'szjam')
brand = Brand.first
kind = Kind.new({name: 'J-10', brand_id: brand.id})
kind.save if kind.valid?
DeviceUuid.new_uuid
end


#device1 = Device.create!(name: '', mac: '')
#device2 = Device.create!(name: '', mac: '')