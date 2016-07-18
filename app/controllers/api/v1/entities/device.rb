# frozen_string_literal: true
module API
  module V1
    module Entities
      class Device < Grape::Entity
        expose :id, documentation: { type: String, desc: 'The id' }
        expose :name, documentation: { type: String, desc: '设备名' }
        expose :serial, documentation: { type: String, desc: '序列号' }
        expose :mac, documentation: { type: String, desc: 'MAC地址' }
        expose :is_online, documentation: { type: String, desc: '是否在线' }
        expose :online_time, documentation: { type: DateTime, desc: '上线时间' }
        expose :offline_time, documentation: { type: DateTime, desc: '下线时间' }
      end
    end
  end
end
