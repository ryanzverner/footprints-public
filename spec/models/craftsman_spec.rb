require 'spec_helper'

describe Craftsman do
  let(:attrs) {{
    name: "Bob",
    status: "Seeking apprentice",
    employment_id: "employment_id",
    skill: '1'
  }}

  before :each do
    @craftsman = Craftsman.create(attrs)
    @applicant = Applicant.create({ name: "Boo",
                                    email: "b@oo.com",
                                    applied_on: "20130101",
                                    assigned_craftsman: @craftsman.name,
                                    craftsman_id: @craftsman.id,
                                    discipline: "software",
                                    skill: "resident",
                                    location: "Chicago" })
  end

  after :all do
    Applicant.destroy_all
    Craftsman.destroy_all
  end

  it "sets the attributes correctly and saves" do
    @craftsman.name.should == attrs[:name]
    @craftsman.status.should == attrs[:status]
  end

  it "associates applicant(s) with craftsman" do
    @craftsman.applicants.first.should == @applicant
  end

  it "returns not_archived applicants by default" do
    archived_applicant = Applicant.create({name: "Boo", email: "b@oo.com", applied_on: "20130101", assigned_craftsman: @craftsman.name,
                                           craftsman_id: @craftsman.id, archived: true, :discipline => "developer", :skill => "resident",
                                           :location => "Chicago"})
    @craftsman.applicants.should_not include(archived_applicant)
  end

  it "can set craftsman to archived" do
    @craftsman.archived.should == false
    @craftsman.flag_archived!
    @craftsman.reload.archived.should == true
  end

  it "creates footprints steward on staging even when default employment_id is taken" do
    Craftsman.create(:name => "Test Craftsman", :employment_id => 999,
                     :email => "testcraftsman@abcinc.com")

    Craftsman.create_footprints_steward(999)
    steward = Craftsman.find_by_email(ENV["STEWARD"])
    expect(steward.employment_id).to eq(1000)
  end

  describe '#is_seeking_for?' do
    context 'skills by key' do
      before :each do
        @craftsman = Craftsman.new(attrs.merge!({ skill: 3 }))
      end

      it 'matches skills by id' do
        expect(@craftsman.is_seeking_for? 3).to eq(true)
      end

      it 'only matches available skills' do
        expect(@craftsman.is_seeking_for? 2).to eq(false)
      end
    end
  end
end
