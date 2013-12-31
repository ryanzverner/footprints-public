require 'warehouse/token_http_client'
require 'warehouse/json_api'
require 'warehouse/craftsmen_sync'
require 'warehouse/api_wrapper'

module Warehouse
  class PrefetchCraftsmen
    def execute(id_token)
      client = Warehouse::TokenHttpClient.new(:host => WAREHOUSE_URL, :id_token => id_token)
      json_api = Warehouse::JsonAPI.new(client)
      wrapper = Warehouse::APIWrapper.new(json_api, Rails.cache)
      Warehouse::CraftsmenSync.new(wrapper).sync
    end
  end
end
