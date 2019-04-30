require 'warehouse/identifiers'

module Warehouse
  class APIWrapper

    def initialize(api, cache)
      @warehouse = api
      @cache     = cache
    end

    def current_crafters
      @cache.fetch("current_crafters", :expires_in => 1.hour, :race_condition_ttl => 5) do
        fetch_crafters.select { |employment| valid_crafter?(employment) }
      end
    end

    def fetch_crafters
      employments = @warehouse.find_all_employments
      employments.map do |employment|
        employment[:id] = employment[:id].to_i
        employment
      end
    end

    private

    def valid_crafter?(employment)
      crafter?(employment) && current?(employment)
    end

    def crafter?(employment)
      CRAFTSMAN_POSITION_NAMES.values.include?(employment[:position][:name])
    end

    def current?(employment)
      employment[:start] < Date.current && (employment[:end].nil? || employment[:end] > Date.today)
    end
  end
end
