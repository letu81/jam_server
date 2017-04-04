class District < ActiveRecord::Base
	validates :code, :uniqueness => true

	belongs_to :parent, foreign_key: 'parent_code', class_name: District

	scope :province, lambda { where("parent_code is null") }
end