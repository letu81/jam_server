# frozen_string_literal: true
# coding: utf-8
require "rest_client"
module API
  module V1
    module Helpers
      module Application
        extend Grape::API::Helpers
	    def warden
	      env['warden']
	    end
	    
	    def max_page_size
	      100
	    end
	    
	    def default_page_size
	      15
	    end
	    
	    def session
	      env[Rack::Session::Abstract::ENV_SESSION_KEY]
	    end
	    
	    def page_size
	      size = params[:size].to_i
	      [size.zero? ? default_page_size : size, max_page_size].min
	    end
	    
	    def current_user
	      token = params[:token]
	      @current_user ||= User.where(private_token: token).first
	    end
	    
	    def deliver_info_for(product)
	      return '' if product.blank?
	    
	      weeks = %w(星期日 星期一 星期二 星期三 星期四 星期五 星期六)
	    
	      order_time_line = SiteConfig.order_time_line || '12:00'
	      if product.delivered_at.blank?
		if Time.zone.now.strftime('%H:%M:%S') < order_time_line
		  week_index = Time.zone.now.wday
		  order_time_line + "前完成下单，今天（#{Time.zone.now.strftime("%Y-%m-%d")} #{weeks[week_index]}）18:00至21:00之间配送"
		else
		  week_index = (Time.zone.now + 1.day).wday
		  order_time_line + "后完成下单，明天（#{(Time.zone.now + 1.day).strftime("%Y-%m-%d")} #{weeks[week_index]}）18:00至21:00之间配送"
		end
	      else
		date = product.delivered_at.strftime('%Y-%m-%d')
		week_index = product.delivered_at.wday
		date + ' ' + order_time_line + "前完成下单，当天（#{date} #{weeks[week_index]}）18:00至21:00之间配送"
	      end
    
	    end
	    
	    def send_sms(mobile, sms_code, error_msg)
	      p sms_code
	      p "==========="
	      url = "https://sms.yunpian.com/v2/sms/tpl_single_send.json"
	      tpl_id = 1689800
	      tpl_value = "#code#=#{sms_code}"
	      RestClient.post(url, 
	      	"apikey=ce8239620a67b5f0f696bef5bb0121a9&mobile=#{mobile}&tpl_id=#{tpl_id}&tpl_value=#{tpl_value}") { |response, request, result, &block|
			puts response
			session.delete(:captcha)
			resp = JSON.parse(response)
			puts resp
			if resp['code'] == 0
			  return { code: 0, message: "ok" }
			else
			  # if resp['code'] == 9 or resp['code'] == 17
			  return { code: 103, message: resp['msg'] }
			  # else
			  #   return { code: 103, message: error_msg }
			  # end
			end
	      }
	    end
	    
	    def authenticate!
	      return { code: 401, message: "用户未登录" } unless current_user
	      current_user
	    end
	    
	    def check_mobile(mobile)
	      return false if mobile.length != 11
	      mobile =~ /\A1[3|4|5|8][0-9]\d{4,8}\z/
	    end
      end
    end
  end
end
