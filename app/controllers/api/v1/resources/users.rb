# frozen_string_literal: true
# coding: utf-8
module API
  module V1
    module Resources
      class Users < API::V1::Root
        helpers API::V1::Helpers::UserParams
        helpers API::V1::Helpers::Application

        resources :users, desc: '注册登录相关接口[OK]' do
          desc '获取短信验证码' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :mobile, type: String, desc: '手机号'
            requires :type, type: Integer, desc: '1 表示注册获取验证码 2 表示重置密码获取验证码 3 表示修改密码获取验证码'
          end

          post '/sms_verification_code' do
            unless check_mobile(params[:mobile])
	            return Failure.new(100, "手机号错误")
	          end
            unless %W(1 2 3).include?(params[:type].to_s)
              return Failure.new(-1, "type参数错误")
            end

            # 检查手机是否符合获取验证码的要求
            type = params[:type].to_i
            user = User.find_by(mobile: params[:mobile])
            if type == 1    # 注册
              return Failure.new(101, "#{params[:mobile]}已经注册") if user.present?
            else # 重置密码和修改密码
              return Failure.new(102, "#{params[:mobile].gsub(/\s+/,"")}未注册") if user.blank?
            end

            # 1分钟内多次提交检测
            sym = "#{params[:mobile]}_#{params[:type]}".to_sym
            if session[sym] && ( Time.now.to_i - session[sym].to_i ) < 60 + rand(3)
              return Failure.new(-5, "同一手机号1分钟内只能获取一次验证码，请稍后重试")
            end

            session[sym] = Time.now.to_i

            # 同一手机一天最多获取5次验证码
            log = SendSmsLog.where('mobile = ? and send_type = ?', params[:mobile], params[:type]).first
            if log.blank?
              log = SendSmsLog.create!(mobile: params[:mobile], send_type: params[:type], first_sms_sent_at: Time.now)
            else
              dt = Time.now.to_i - log.first_sms_sent_at.to_i
              if dt > 24 * 3600 # 超过24小时都要重置发送记录
                log.sms_total = 0
                log.first_sms_sent_at = Time.now
                log.save!
              else # 24小时以内
                if log.sms_total.to_i >= 5 # 达到5次
                  return Failure.new(-10, "同一手机号24小时内只能获取5次验证码，请稍后再试")
                end
              end
            end

            # 获取验证码并发送
            code = AuthCode.where('mobile = ? and verified = ? and c_type = ?', params[:mobile], true, type).first
            code = AuthCode.create!(mobile: params[:mobile], c_type: type) if code.blank?
  
            if code          
              result = send_sms(params[:mobile], "【佳安美智控】您的验证码是#{code.code}，5分钟内有效。若非本人操作，请忽略", "获取验证码失败")
              if result['code'].to_i == 103
                # 发送失败，更新每分钟发送限制
                session.delete(sym)
              end
              if result['code'].to_i == 0
                # 发送成功，更新发送日志
                log.update_attribute(:sms_total, log.sms_total + 1)
              end
              result
            else
              Failure.new(-100, "验证码生成错误，请重试")
            end
          end

          desc '登录' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :mobile, type: String, desc: 'User mobile'
            requires :password, type: String, desc: 'User password'
          end
          post '/login' do
            user = User.where(["mobile = :value", { value: params[:mobile].downcase }]).first
            unless user
              return { code: 102, message: "用户未注册" } 
            end
            password = Base64.decode64(params[:password])
            #password = params[:password]
            if user.valid_password?(password)
              { code: 0, message: "ok", data: { token: user.private_token || "", id: user.id, username: user.username } }
            else
              { code: 107, message: "登录密码不正确" }
            end
          end

          desc '注册' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :mobile, type: String, desc: 'User mobile'
            requires :password, type: String, desc: 'User password'
            requires :verification_code, type: String, desc: 'Sms verification_code'
          end
          post '/register' do
            unless check_mobile(params[:mobile])
              return Failure.new(100, "不正确的手机号")
            end
        
            user = User.find_by(mobile: params[:mobile])
            if user.present?
              return Failure.new(101, "#{params[:mobile]}已经注册")
            end
        
            ac = AuthCode.where('mobile = ? and code = ? and verified = ?', params[:mobile], params[:verification_code], true).first
            return Failure.new(104, "验证码无效") if ac.blank?

        
            #password = Base64.decode64(params[:password])
            password = params[:password]
            if password.length < 6
              return Failure.new(105, "密码太短，至少为6位")
            end

            @user = User.new(email: "#{params[:mobile].gsub(/\s+/,"")}@jiananmei.com", mobile: params[:mobile].gsub(/\s+/, ''), password: password, password_confirmation: password, username: "#{params[:mobile].gsub(/\s+/,"")}")
            if @user.save
              warden.set_user(@user)
              ac.update_attribute(:verified, false)
              { code: 0, message: "用户注册成功" }
            else
              return Failure.new(106, "用户注册失败")
            end
          end

          desc '修改用户密码' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :old_password, type: String, desc: 'User old password'
            requires :password, type: String, desc: 'User new password'
            requires :token, type: String, desc: 'User auth token'
          end
          put '/password' do
            user = authenticate!
            #old_password = Base64.decode64(params[:old_password])
            old_password = params[:old_password]
            unless user.valid_password?(old_password)
              return Failure.new(109, "旧密码不正确")
            end

            #new_password = Base64.decode64(params[:password])
            new_password = params[:password]
            if new_password.length < 6
              return Failure.new(105, "密码太短，至少为6位")
            end
        
            if user.update_attribute(:password, new_password)
              { code: 0, message: "ok" }
            else
              return Failure.new(110, "修改密码失败")
            end
          end

          desc '重置密码' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :mobile, type: String, desc: 'User mobile'
            requires :password, type: String, desc: 'User new password'
            requires :verification_code, type: String, desc: 'Sms verification_code'
          end
          post '/password/reset' do
            unless check_mobile(params[:mobile])
              return Failure.new(100, "不正确的手机号")
            end
            @user = User.find_by(mobile: params[:mobile])
            if @user.blank?
              return Failure.new(102, "#{params[:mobile]}未注册")
            end
        
            ac = AuthCode.where('mobile = ? and code = ? and verified = ?', params[:mobile],params[:verification_code],true).first
            if ac.blank?
              return Failure.new(104, "验证码无效")
            end
        
            #password = Base64.decode64(params[:password])
            password = params[:password]
            if password.length < 6
              return Failure.new(105, "密码太短，至少为6位")
            end
        
            if @user.update_attribute(:password, password)
              { code: 0, message: "ok" }
            else
              Failure.new(108, "重置密码失败")
            end
          end

          desc '修改用户名' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :username, type: String, desc: 'User name'
            requires :token, type: String, desc: 'User auth token'
          end
          put '/username' do
            user = authenticate!
            if params["username"].length < 3 || params["username"].length > 20 
              return Failure.new(105, "用户名长度为3-20")
            end
        
            if user.update_attribute(:username, params["username"])
              { code: 0, message: "ok" }
            else
              return Failure.new(108, "修改用户名失败")
            end
          end
        end
      end
    end
  end
end
