# frozen_string_literal: true
module API
  module V1
    module Resources
      class Locksmiths < API::V1::Root
        helpers API::V1::Helpers::Application

        resource :locksmiths, desc: '锁匠相关接口' do

          desc '附近锁匠列表' do
            headers API::V1::Defaults.auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            optional :page, type: Integer, desc: 'page'
          end
          post '/nearby' do
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            page = params[:page].to_i
            datas = []
            if user.district_code.nil?
              return { code: 0, message: "ok", data: datas, total_pages: 1, current_page: 1 } 
            else
              locksmiths = Locksmith.district(user.district_code).verified.page(page).per(default_page_size)
              locksmiths.each do |locksmith|
                datas << {id: locksmith.id, name: locksmith.name, 
                          address: locksmith.address, avatar_path: locksmith.avatar,
                          mobile: locksmith.mobile, certificate_number: locksmith.certificate_number}
              end
              return { code: 0, message: "ok", data: datas, total_pages: locksmiths.total_pages, current_page: page } 
            end
          end


          desc '锁匠信息' do
            headers API::V1::Defaults.auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
            requires :locksmith_id, type: Integer, desc: 'Locksmith id'
          end
          post '/show' do
            user = current_user
            unless user
                return { code: 401, message: "用户未登录", data: "" }
            end
            data = []
            locksmith = Locksmith.where(id: params[:locksmith_id]).first
            data = {id: locksmith.id, name: locksmith.name, 
                    phone: locksmith.phone, qq: locksmith.qq,
                    address: locksmith.address, avatar_path: locksmith.avatar,
                    mobile: locksmith.mobile, certificate_number: locksmith.certificate_number,
                    company_info: locksmith.company_info, company_service: locksmith.company_service
                  }
            return { code: 0, message: "ok", data: data } 
          end

        end
      end
    end
  end
end