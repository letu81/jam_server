# frozen_string_literal: true
module API
  module V1
    module Resources
      class Products < API::V1::Root
        helpers API::V1::Helpers::Application

        resource :products, desc: '商品相关接口' do

          desc '热卖商品列表' do
            headers API::V1::Defaults.auth_headers
          end
          params do
            requires :token, type: String, desc: 'User token'
          end
          post '/hot' do
            user = authenticate!

            datas = []
            datas << {id:1, name: "瑞玛特 A6", sale_num: 0, sale_price: 2499.0, price: 3200.0, 
                      avatar_path: "pictures/products/lock/A6.png", desc_paths: "", 
                      store_path: "https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-16019892495.6.EaXaq7&id=548763023269"}
            datas << {id:1, name: "瑞玛特 K6", sale_num: 0, sale_price: 2200.0, price: 2680.0, 
                      avatar_path: "pictures/products/lock/K6.png", desc_paths: "", 
                      store_path: "https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-16019892495.2.EaXaq7&id=548771087076"}
            return { code: 0, message: "ok", data: datas, total_pages: 1, current_page: 1 } 
          end

        end
      end
    end
  end
end