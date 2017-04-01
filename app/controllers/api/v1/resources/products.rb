# frozen_string_literal: true
module API
  module V1
    module Resources
      class Products < API::V1::Root
        helpers API::V1::Helpers::Application

        resource :products, desc: '商品相关接口' do

          desc '热卖商品列表' do
            headers API::V1::Defaults.auth_headers
            success API::V1::Entities::Device
          end
          params do
            requires :token, type: String, desc: 'User token'
          end
          post '/hot' do
            user = authenticate!

            datas = []
            datas << {id:1, name: "jam j10", sale_num: 180, sale_price: 1980.0, price: 2380.0, avatar_path: "public/pictures/products/lock/j10.jpg", desc_paths: ""}
            datas << {id:1, name: "jam j08", sale_num: 180, sale_price: 1680.0, price: 2180.0, avatar_path: "public/pictures/products/lock/j08.jpg", desc_paths: ""}
            return { code: 0, message: "ok", data: datas, total_pages: 1, current_page: 1 } 
          end

        end
      end
    end
  end
end