require 'spec_helper'

describe Crafter do
  let(:attrs) {{
    name: "Bob",
    status: "Seeking apprentice",
    employment_id: "employment_id",
    skill: '1'
  }}

  before :each do
    @crafter = Crafter.create(attrs)
    @applicant = Applicant.create({ name: "Boo",
                                    email: "b@oo.com",
                                    applied_on: "20130101",
                                    assigned_crafter: @crafter.name,
                                    crafter_id: @crafter.id,
                                    discipline: "software",
                                    skill: "resident",
                                    location: "Chicago" })
  end

  after :all do
    Applicant.destroy_all
    Crafter.destroy_all
  end

  it "sets the attributes correctly and saves" do
    @crafter.name.should == attrs[:name]
    @crafter.status.should == attrs[:status]
  end

  it "associates applicant(s) with crafter" do
    @crafter.applicants.first.should == @applicant
  end

  it "returns not_archived applicants by default" do
    archived_applicant = Applicant.create({name: "Boo", email: "b@oo.com", applied_on: "20130101", assigned_crafter: @crafter.name,
                                           crafter_id: @crafter.id, archived: true, :discipline => "developer", :skill => "resident",
                                           :location => "Chicago"})
    @crafter.applicants.should_not include(archived_applicant)
  end

  it "can set crafter to archived" do
    @crafter.archived.should == false
    @crafter.flag_archived!
    @crafter.reload.archived.should == true
  end

  it "creates footprints steward on staging even when default employment_id is taken" do
    Crafter.create(:name => "Test Crafter", :employment_id => 999,
                     :email => "testcrafter@abcinc.com")

    Crafter.create_footprints_steward(999)
    steward = Crafter.find_by_email(ENV["STEWARD"])
    expect(steward.employment_id).to eq(1000)
  end

  describe '#is_seeking_for?' do
    context 'skills by key' do
      before :each do
        @crafter = Crafter.new(attrs.merge!({ skill: 3 }))
      end

      it 'matches skills by id' do
        expect(@crafter.is_seeking_for? 3).to eq(true)
      end

      it 'only matches available skills' do
        expect(@crafter.is_seeking_for? 2).to eq(false)
      end
    end
  end
end
