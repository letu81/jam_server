namespace :version do
  	desc 'new version'
    
    namespace :android do
	  	task new: :environment do
	  		content = ""
	  		version = AppVersion.new({code: 9, name: '1.0.8', mobile_system: AppVersion::SYSTEMS[:android], content: ""})
	  		version.save if version.valid?
	  	end
    end

    namespace :ios do
	  	task new: :environment do
	  		content = ""
	  		version = AppVersion.new({code: 1, name: '1.0.0', mobile_system: AppVersion::SYSTEMS[:ios], content: content})
	  		version.save if version.valid?
	  	end
    end

end