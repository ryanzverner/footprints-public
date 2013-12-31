require 'applicant_dispatch/util/aggregate'

module TestFilters
  class DropFirstFilter
    def call(items)
      first, *rest = items

      rest
    end
  end
end

module ApplicantDispatch
  describe Aggregate do
    it "reduces the items with each supplied function" do
      items = [:one, :two, :three, :four]

      aggregate = Aggregate.new(TestFilters::DropFirstFilter.new,
                                TestFilters::DropFirstFilter.new,
                                TestFilters::DropFirstFilter.new)

      results = aggregate.call(items)

      expect(results).to eq([:four])
    end
  end
end
