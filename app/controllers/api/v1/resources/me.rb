# frozen_string_literal: true
module API
  module V1
    module Resources
      class Me < API::V1::Root
        helpers API::V1::Helpers::Application
        helpers API::V1::Helpers::UserParams

        resource :me, desc: '个人相关接口' do
          desc '个人信息' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
          end
          post '/' do
            user = authenticate!
            datas = {:name => user.username, :mobile => user.mobile}
            p datas
            return { code: 0, message: "ok", data: datas } 
          end

          desc '消息列表' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
          end
          post '/messages' do
            user = authenticate!
            datas = []
            datas << { id: 1, user_id: 1, user_name: "tutu回家了", oper_time: "3分钟前", content: "动态密码开门" }
            datas << { id: 2, user_id: 1, user_name: "tutu回家了", oper_time: "2小时前", content: "一号指纹开门" }
            return { code: 0, message: "ok", data: datas } 
          end

          desc '反馈意见' do
            headers API::V1::Defaults.client_auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            optional :title, type: String, desc: 'title'
            optional :content, type: String, desc: 'content'
          end
          post '/feedback' do
            user = authenticate!
            return { code: 0, message: "ok", data: ""}
          end
        end
      end
    end
  end
end
