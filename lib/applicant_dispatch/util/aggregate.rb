module ApplicantDispatch
  class Aggregate
    attr_reader :filters

    def initialize(*filters)
      @filters = filters
    end

    def call(reducible, *args)
      filters.reduce(reducible) do |results, filter|
        filter.call(results, *args)
      end
    end
  end
end
