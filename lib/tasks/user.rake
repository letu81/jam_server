namespace :user do
  	desc 'update user'
    
    namespace :update do
    	
    	desc 'update password'
	  	task password: :environment do
	  		new_password = "111111"
			user = User.where(mobile: '15712000000').first
			user.update_attribute(:password, new_password) if user
	  	end

	  	desc 'update username'
	  	task username: :environment do
			User.where("mobile = username").update_all("username = '我'")
	  	end

    end

end