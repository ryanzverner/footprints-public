require 'warehouse/identifiers'

module Warehouse
  class APIWrapper

    def initialize(api, cache)
      @warehouse = api
      @cache     = cache
    end

    def current_craftsmen
      @cache.fetch("current_craftsmen", :expires_in => 1.hour, :race_condition_ttl => 5) do
        fetch_craftsmen.select { |employment| valid_craftsman?(employment) }
      end
    end

    def fetch_craftsmen
      employments = @warehouse.find_all_employments
      employments.map do |employment|
        employment[:id] = employment[:id].to_i
        employment
      end
    end

    private

    def valid_craftsman?(employment)
      craftsman?(employment) && current?(employment)
    end

    def craftsman?(employment)
      CRAFTSMAN_POSITION_NAMES.values.include?(employment[:position][:name])
    end

    def current?(employment)
      employment[:start] < Date.current && (employment[:end].nil? || employment[:end] > Date.today)
    end
  end
end
