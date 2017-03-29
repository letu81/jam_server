class JamService < ActiveRecord::Base
	TAPES = {:app_support => 1}

    belongs_to :user
    
    scope :app_support, lambda { where(service_type: TAPES[:app_support]) }
    scope :user, lambda { |user_id| where(user_id: user_id) }
    scope :not_recall, lambda { where(is_recall: false) }
    scope :recalled, lambda { where(is_recall: true) }

	scope :resent, lambda { where("created_at > ?", 1.week.ago) }
end