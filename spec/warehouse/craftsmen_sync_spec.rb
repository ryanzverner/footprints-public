require_relative "spec_helpers/employment_factory"
require "warehouse/crafters_sync"
require "spec_helper"

describe Warehouse::CraftsmenSync do
  let(:repo)  { Footprints::Repository }
  let(:toby)  { Warehouse::SpecHelpers.create_employment({:id => 1, :first_name => "Toby",  :last_name => "Flenderson", :email => "tflenderson@dundermifflin.com", :start => Date.today - 14, :end => Date.today - 7, :position_name => "UX Crafter"})}
  let(:holly) { Warehouse::SpecHelpers.create_employment({:id => 2, :first_name => "Holly", :last_name => "Flax",       :email => "hflax@dundermifflin.com",       :start => Date.today - 7, :position_name => "Software Crafter"}) }
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
  let(:crafters_sync) { Warehouse::CraftsmenSync.new(api) }

  before(:each) { repo.crafter.destroy_all }

  it "creates crafters if they dont exist in footprints" do
    allow(api).to receive(:current_crafters) { [toby, mike, paul, holly] }
    crafters_sync.sync
    expect(repo.crafter.all.count).to eq(4)
  end

  it "updates crafters if they already exist in footprints" do
    repo.crafter.create(:name => "Stanley Hudson", :email => "shudson@dundermifflin.com", :employment_id => 111)
    allow(api).to receive(:current_crafters) { [toby] }
    crafters_sync.sync
    expect(repo.crafter.all.count).to   eq(1)
    expect(repo.crafter.first.name).to  eq("Toby Flenderson")
    expect(repo.crafter.first.email).to eq("tflenderson@dundermifflin.com")
  end

  it "archives crafters that exist in footprints, but no longer exist in warehouse" do
    crafter_toby  = repo.crafter.create(:name => "Toby Flenderson", :email => "tflenderson@dundermifflin.com", :employment_id => 222)
    crafter_holly = repo.crafter.create(:name => "Holly Flax",      :email => "hflax@dundermifflin.com",       :employment_id => 333)
    allow(api).to receive(:current_crafters) { [toby] }
    crafters_sync.sync
    crafter_toby = repo.crafter.find_by_employment_id(1)
    expect(repo.crafter.all.count).to        eq(1)
    expect(repo.crafter.first).to            eq(crafter_toby)
    expect(crafter_toby.reload.archived).to  be_false
    expect(crafter_holly.reload.archived).to be_true
  end

  it "associates footprints crafter to their footprints user" do
    repo.user.create(:email => "tflenderson@dundermifflin.com", :uid => "007")
    allow(api).to receive(:current_crafters) { [toby] }
    crafters_sync.sync
    crafter_toby = repo.crafter.first
    user_toby = repo.user.first
    expect(user_toby.crafter_id).to eq crafter_toby.id
  end

  it "unarchives crafters that had previously been archived if added back into warehouse" do
    repo.crafter.create(:name => "Toby Flenderson", :email => "tflenderson@dundermifflin.com", :employment_id => 1, :archived => true)
    allow(api).to receive(:current_crafters) { [toby] }
    crafters_sync.sync
    crafter_toby = repo.crafter.find_by_employment_id(1)
    expect(crafter_toby.archived).to be_false
  end
end
