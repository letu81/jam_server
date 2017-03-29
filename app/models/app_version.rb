class AppVersion < ActiveRecord::Base
	SYSTEMS = {:android => 1, :ios => 2, :windows => 3, :wechat => 4}

	validates :code, :uniqueness => {scope: [:mobile_system]}
	validates :name, :uniqueness => {scope: [:mobile_system]}

	default_scope { order("id desc") }

	def self.by_system(mobile_system)
		self.where(:mobile_system => mobile_system)
	end

	def self.by_system_and_code(mobile_system, version_code)
		self.where(:mobile_system => mobile_system, :code => version_code)
	end

	def self.by_system_and_name(mobile_system, version_name)
		self.where(:mobile_system => mobile_system, :name => version_name)
	end

	def self.latest_by_system(mobile_system)
		self.where(:mobile_system => mobile_system).order("code desc").first
	end
end