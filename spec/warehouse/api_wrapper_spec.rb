require_relative 'spec_helpers/employment_factory'
require_relative 'spec_helpers/test_cache'
require 'warehouse/api_wrapper'

describe Warehouse::APIWrapper do
  let(:holly) { Warehouse::SpecHelpers.create_employment({:id => 1, :first_name => "Holly",
                                                          :last_name => "Flax",
                                                          :email => "hflax@dundermifflin.com",
                                                          :start => Date.today - 7,
                                                          :position_name => "Software Craftsman"}) }
  let(:bob)  { Warehouse::SpecHelpers.create_employment({:id => 2, :first_name => "Bob",
                                                          :last_name => "Vance",
                                                          :email => "bvance@vancerefrig.com",
                                                          :start => Date.today - 14,
                                                          :end => Date.today - 7,
                                                          :position_name => "Software Craftsman"})}
  let(:jim) { Warehouse::SpecHelpers.create_employment({:id => 5, :first_name => "Jim",
                                                        :last_name => "Halpert",
                                                        :email => "jhalpert@dundermiffline.com",
                                                        :start => Date.today + 6.months,
                                                        :position_name => "Software Craftsman"})}
  let(:paul) { Warehouse::SpecHelpers.create_employment({:id => 6,
                                                         :first_name => "Paul",
                                                         :last_name => "Pagel",
                                                         :email => "pp@8l.com",
                                                         :start => Date.today - 7,
                                                         :position_name => "Chief Executive Officer"}) }
  let(:mike) { Warehouse::SpecHelpers.create_employment({:id => 7,
                                                         :first_name => "Mike",
                                                         :last_name => "Rodriguez",
                                                         :email => "mj@8l.com",
                                                         :start => Date.today - 7,
                                                         :position_name => "Vice President of Operations"}) }
  let(:warehouse_api) { double(:find_all_employments => [bob, holly, jim, paul, mike]) }
  let(:warehouse_wrapper) { Warehouse::APIWrapper.new(warehouse_api, Warehouse::SpecHelpers::TestCache.new(:no_cache)) }

  context "#craftsmen" do
    it "only considers craftsmen with past start dates to be current craftsman" do
      expect(warehouse_api).to receive(:find_all_employments)
      expect(warehouse_wrapper.current_craftsmen).to eq([holly, paul, mike])
    end

    it "caches craftsmen, so it doesnt have to hit warehouse everytime" do
      warehouse_wrapper = Warehouse::APIWrapper.new(warehouse_api, Warehouse::SpecHelpers::TestCache.new(:with_cache))
      expect(warehouse_api).to receive(:find_all_employments).once
      3.times { warehouse_wrapper.current_craftsmen }
    end
  end
end
