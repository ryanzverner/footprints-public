module Warehouse
  module SpecHelpers
    class TestCache
      def initialize(should_cache = :no_cache)
        @should_cache = (should_cache == :with_cache) ? true : false
        @cache = {}
      end

      def fetch(name, options = {})
        if @should_cache
          @cache[name] ||= yield
        else
          yield
        end
      end
    end
  end
end
