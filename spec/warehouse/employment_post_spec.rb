require 'ostruct'
require 'warehouse/employment_post'

describe Warehouse::EmploymentPost do
  let(:warehouse_api) { double }
  let(:employment_post) { Warehouse::EmploymentPost.new(warehouse_api) }

  let(:start) {
    Date.parse("February 9 2015")
  }

  let(:end_date) {
    Date.parse("February 11 2015")
  }

  it "creates a resident apprentice employment, software craftsman employment, and person in warehouse" do
    expect(warehouse_api).to receive(:create_person!).with({
      :first_name => "Bob", 
      :last_name => "Vance",
      :email => "bob.vance@example.com"
    } ) { "1" }

    expect(warehouse_api).to receive(:create_employment!).with({
      :person_id => "1", 
      :position_name => "Software Resident", 
      :start => start,
      :end => end_date}) { "1" }

    expect(warehouse_api).to receive(:create_employment!).with({
      :person_id => "1", 
      :position_name => "Software Craftsman", 
      :start => Date.parse("February 16 2015"),
      :end => nil}) { "1" }

    expect(employment_post.add_resident!(OpenStruct.new({
      :first_name => "Bob", 
      :last_name => "Vance",
      :email => "bob.vance@example.com",
      :discipline => "Developer", 
      :start_date => start,
      :end_date => end_date}))).to eq("1")
  end

  it "creates a ux apprentice employment, ux craftsman employment, and person in warehouse" do
    expect(warehouse_api).to receive(:create_person!).with({
      :first_name => "Bob", 
      :last_name => "Vance",
      :email => "bob.vance@example.com"
    }) { "1" }

    expect(warehouse_api).to receive(:create_employment!).with({
      :person_id => "1", 
      :position_name => "UX Resident", 
      :start => start,
      :end => end_date}) { "1" }

    expect(warehouse_api).to receive(:create_employment!).with({
      :person_id => "1", 
      :position_name => "UX Craftsman", 
      :start => Date.parse("February 16 2015"),
      :end => nil}) { "1" }

    expect(employment_post.add_resident!(OpenStruct.new({
      :first_name => "Bob", 
      :last_name => "Vance", 
      :discipline => "Designer", 
      :start_date => start, 
      :email => "bob.vance@example.com",
      :end_date => end_date}))).to eq("1")
  end

  it "creates a student apprentice person in warehouse" do
    allow_any_instance_of(Warehouse::EmploymentPost).to receive(:find_craftsman_person_id).and_return(1)
    expect(warehouse_api).to receive(:create_person!).with({
      :first_name => "Bob", 
      :last_name => "Vance",
      :email => "bob.vance@example.com"
    } ) { "1" } 

     expect(warehouse_api).to receive(:create_apprenticeship!).with({
        :person_id =>"1",
        :skill_level => "student",
        :start => start,
        :end => end_date,
        :mentorships => [{
          :person_id => 1,
          :start => start,
          :end => end_date}]
     }) { "1" } 

    expect(employment_post.add_student!(OpenStruct.new({
      :first_name => "Bob", 
      :last_name => "Vance", 
      :discipline => "Designer", 
      :start_date => start, 
      :email => "bob.vance@example.com",
      :end_date => end_date}))).to eq("1")
  end
end
