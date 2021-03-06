# frozen_string_literal: true
# coding: utf-8
module API
  module V1
    module Resources
      class Users < API::V1::Root
        helpers API::V1::Helpers::UserParams
        helpers API::V1::Helpers::Application

        resources :users, desc: '注册登录相关接口' do
          desc '获取短信验证码' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :mobile, type: String, desc: '手机号'
            requires :type, type: Integer, desc: '1 表示注册获取验证码 2 表示重置密码获取验证码 3 表示修改密码获取验证码 4 修改手机号码'
          end

          post '/sms_verification_code' do
            unless check_mobile(params[:mobile])
	            return Failure.new(100, "手机号错误")
	          end
            unless %W(1 2 3 4).include?(params[:type].to_s)
              return Failure.new(-1, "type参数错误")
            end

            # 检查手机是否符合获取验证码的要求
            type = params[:type].to_i
            user = User.find_by(mobile: params[:mobile])
            if type == 1    # 注册
              return Failure.new(101, "#{params[:mobile]}已经注册") if user.present?
            elsif type == 4 # 修改手机号码
              return Failure.new(101, "#{params[:mobile]}已经被占用") if user.present?
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
              result = send_sms(params[:mobile], code.code, "获取验证码失败")
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

          desc '检测手机号及验证码并注册' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :username, type: String, desc: '用户名'
            requires :mobile, type: String, desc: '手机号'
            requires :verification_code, type: String, desc: '验证码'
            requires :type, type: Integer, desc: '1 表示注册获取验证码 2 表示重置密码获取验证码 3 表示修改密码获取验证码 4 修改手机号码'
          end
          post '/verify_and_register' do
            unless check_mobile(params[:mobile])
              return Failure.new(100, "手机号错误")
            end
            unless %W(1 2 3 4).include?(params[:type].to_s)
              return Failure.new(-1, "type参数错误")
            end
            user = User.find_by(mobile: params[:mobile])
            if user.present?
              return Failure.new(101, "#{params[:mobile]}已经注册")
            end
            ac = AuthCode.where('mobile = ? and code = ? and verified = ?', params[:mobile], params[:verification_code], true).first
            if ac.blank?
              return Failure.new(104, "验证码无效")
            else
              password = SecureRandom.hex[0..7]
              @user = User.new(email: "#{params[:mobile].gsub(/\s+/,"")}@jiaanmei.com", mobile: params[:mobile].gsub(/\s+/, ''), password: password, password_confirmation: password, username: params[:username])
              if @user.save
                warden.set_user(@user)
                #ac.update_attribute(:verified, false)
                return { code: 0, message: "ok", data: { token: @user.private_token || "", id: @user.id, username: @user.username } }
              else
                return Failure.new(106, "用户注册失败")
              end
            end
          end

          desc '检测手机号及验证码' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :mobile, type: String, desc: '手机号'
            requires :verification_code, type: String, desc: '验证码'
            requires :type, type: Integer, desc: '1 表示注册获取验证码 2 表示重置密码获取验证码 3 表示修改密码获取验证码 4 修改手机号码'
          end
          post '/verify_sms_verification_code' do
            unless check_mobile(params[:mobile])
              return Failure.new(100, "手机号错误")
            end
            unless %W(1 2 3 4).include?(params[:type].to_s)
              return Failure.new(-1, "type参数错误")
            end
            user = User.find_by(mobile: params[:mobile])
            unless user.present?
              return Failure.new(101, "#{params[:mobile]}未注册")
            end
            ac = AuthCode.where('mobile = ? and code = ? and verified = ?', params[:mobile], params[:verification_code], true).first
            if ac.blank?
              return Failure.new(104, "验证码无效")
            else
              #if ac.update_attribute(:verified, false)
                return { code: 0, message: "ok", data: {} }
              #else
              #  return Failure.new(106, "验证失败")
              #end
            end
          end

          desc '登录' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :mobile, type: String, desc: 'User mobile'
            requires :password, type: String, desc: 'User password'
            optional :mac, type: String, desc: 'User mobile mac'
          end
          post '/login' do
            user = User.where(["mobile = :value", { value: params[:mobile].downcase }]).first
            unless user
              return { code: 102, message: "用户未注册" } 
            end
            password = params[:phone_info].nil? ? Base64.decode64(params[:password]) : params[:password]
            #password = params[:password]
            if user.valid_password?(password)
              if !params["mac"].nil? && !params["mac"].blank?
                app_key = Setting.jpush_app_key
                master_secret = Setting.jpush_app_secret
                jpush = JPush::Client.new(app_key, master_secret)
                pusher = jpush.pusher
                notification = JPush::Push::Notification.new
                alert = "主人，您的帐号在另一台手机上登陆，请确认您的账号和密码是否泄露。"
                extras = {user_id: user.id, type: 'login'}
                notification.set_alert(alert).set_android(
                    alert: alert,
                    title: "佳安美智控通知",
                    builder_id: 1,
                    extras: extras
                ).set_ios(
                    alert: alert,
                    contentavailable: true,
                    extras: extras
                )
                audience = JPush::Push::Audience.new
                audience.set_alias(user.id.to_s).set_tag_not([params["mac"], "logout"])
                push_payload = JPush::Push::PushPayload.new(
                  platform: 'all',
                  audience: audience,
                  notification: notification
                )
                pusher.push(push_payload)
              end
              device_num = UserDevice.user(user.id).length
              expired_at = Time.now + 2.weeks
              user.update_attribute(:remember_created_at, expired_at)
              return { code: 0, message: "ok", data: { token: user.private_token || "", id: user.id, username: user.username, adcode: user.district_code, device_num: device_num, avatar: user.avatar.blank? ? "" : user.avatar, expired_at: expired_at.to_i } }
            else
              return { code: 107, message: "登录密码不正确" }
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
        
            password = Base64.decode64(params[:password])
            if password.length < 6
              return Failure.new(105, "密码太短，至少为6位")
            end

            @user = User.new(email: "#{params[:mobile].gsub(/\s+/,"")}@jiaanmei.com", mobile: params[:mobile].gsub(/\s+/, ''), password: password, password_confirmation: password, username: "#{params[:mobile].gsub(/\s+/,"")}")
            if @user.save
              warden.set_user(@user)
              ac.update_attribute(:verified, false)
              return { code: 0, message: "ok", data: { token: @user.private_token || "", id: @user.id, username: @user.username } }
            else
              return Failure.new(106, "用户注册失败")
            end
          end

          desc '设置用户密码' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :password, type: String, desc: 'User old password'
            requires :token, type: String, desc: 'User auth token'
          end
          post '/password/create' do
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            new_password = Base64.decode64(params[:new_password])
            if user.update_attribute(:password, new_password)
              return { code: 0, message: "ok" }
            else
              return Failure.new(110, "设置密码失败")
            end
          end

          desc '修改用户密码' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :password, type: String, desc: 'User old password'
            requires :new_password, type: String, desc: 'User new password'
            requires :token, type: String, desc: 'User auth token'
          end
          post '/password' do
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            old_password = Base64.decode64(params[:password])
            unless user.valid_password?(old_password)
              return Failure.new(109, "旧密码不正确")
            end

            new_password = Base64.decode64(params[:new_password])
            if new_password.length < 6
              return Failure.new(105, "密码太短，至少为6位")
            end
        
            if user.update_attribute(:password, new_password)
              return { code: 0, message: "ok" }
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
        
            password = Base64.decode64(params[:password])
            if password.length < 6
              return Failure.new(105, "密码太短，至少为6位")
            end
        
            if @user.update_attribute(:password, password)
              return { code: 0, message: "ok" }
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
          post '/username' do
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            if params["username"].length < 3 || params["username"].length > 20 
              return Failure.new(105, "用户名长度为3-20")
            end
        
            if user.update_attribute(:username, params["username"])
              return { code: 0, message: "ok" }
            else
              return Failure.new(108, "修改用户名失败")
            end
          end

          desc '修改手机' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :mobile, type: String, desc: 'User new mobile'
            requires :token, type: String, desc: 'User auth token'
            requires :verification_code, type: String, desc: 'Sms verification_code'
          end
          post '/update/mobile' do
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            unless check_mobile(params[:mobile])
              return Failure.new(100, "不正确的手机号")
            end

            if user.mobile == params[:mobile].strip
              return Failure.new(101, "与原手机号相同")
            end

            @user = User.find_by(mobile: params[:mobile])
            unless @user.blank?
              return Failure.new(102, "#{params[:mobile]}已经被占用")
            end

            ac = AuthCode.where('mobile = ? and code = ? and verified = ?', params[:mobile], params[:verification_code], true).first
            if ac.blank?
              return Failure.new(104, "验证码无效")
            end

            if user.update_attribute(:mobile, params["mobile"])
              return { code: 0, message: "ok" }
            else
              return Failure.new(108, "修改手机失败")
            end
          end
        end
      end
    end
  end
end