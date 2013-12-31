require_relative "spec_helpers/employment_factory"
require "warehouse/craftsmen_sync"
require "spec_helper"

describe Warehouse::CraftsmenSync do
  let(:repo)  { Footprints::Repository }
  let(:toby)  { Warehouse::SpecHelpers.create_employment({:id => 1, :first_name => "Toby",  :last_name => "Flenderson", :email => "tflenderson@dundermifflin.com", :start => Date.today - 14, :end => Date.today - 7, :position_name => "UX Craftsman"})}
  let(:holly) { Warehouse::SpecHelpers.create_employment({:id => 2, :first_name => "Holly", :last_name => "Flax",       :email => "hflax@dundermifflin.com",       :start => Date.today - 7, :position_name => "Software Craftsman"}) }
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
  let(:api)   { double("warehouse_api_wrapper") }
  let(:craftsmen_sync) { Warehouse::CraftsmenSync.new(api) }

  before(:each) { repo.craftsman.destroy_all }

  it "creates craftsmen if they dont exist in footprints" do
    allow(api).to receive(:current_craftsmen) { [toby, mike, paul, holly] }
    craftsmen_sync.sync
    expect(repo.craftsman.all.count).to eq(4)
  end

  it "updates craftsmen if they already exist in footprints" do
    repo.craftsman.create(:name => "Stanley Hudson", :email => "shudson@dundermifflin.com", :employment_id => 111)
    allow(api).to receive(:current_craftsmen) { [toby] }
    craftsmen_sync.sync
    expect(repo.craftsman.all.count).to   eq(1)
    expect(repo.craftsman.first.name).to  eq("Toby Flenderson")
    expect(repo.craftsman.first.email).to eq("tflenderson@dundermifflin.com")
  end

  it "archives craftsmen that exist in footprints, but no longer exist in warehouse" do
    craftsman_toby  = repo.craftsman.create(:name => "Toby Flenderson", :email => "tflenderson@dundermifflin.com", :employment_id => 222)
    craftsman_holly = repo.craftsman.create(:name => "Holly Flax",      :email => "hflax@dundermifflin.com",       :employment_id => 333)
    allow(api).to receive(:current_craftsmen) { [toby] }
    craftsmen_sync.sync
    craftsman_toby = repo.craftsman.find_by_employment_id(1)
    expect(repo.craftsman.all.count).to        eq(1)
    expect(repo.craftsman.first).to            eq(craftsman_toby)
    expect(craftsman_toby.reload.archived).to  be_false
    expect(craftsman_holly.reload.archived).to be_true
  end

  it "associates footprints craftsman to their footprints user" do
    repo.user.create(:email => "tflenderson@dundermifflin.com", :uid => "007")
    allow(api).to receive(:current_craftsmen) { [toby] }
    craftsmen_sync.sync
    craftsman_toby = repo.craftsman.first
    user_toby = repo.user.first
    expect(user_toby.craftsman_id).to eq craftsman_toby.id
  end

  it "unarchives craftsmen that had previously been archived if added back into warehouse" do
    repo.craftsman.create(:name => "Toby Flenderson", :email => "tflenderson@dundermifflin.com", :employment_id => 1, :archived => true)
    allow(api).to receive(:current_craftsmen) { [toby] }
    craftsmen_sync.sync
    craftsman_toby = repo.craftsman.find_by_employment_id(1)
    expect(craftsman_toby.archived).to be_false
  end
end
