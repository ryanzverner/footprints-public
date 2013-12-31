require 'spec_helper'

describe ApplicantsHelper do
  it "formats labels" do
    format_label("this_is_a_label").should == "This Is A Label"
  end

  it "returns the days since the last action for an applicant" do
    applicant = Footprints::Repository.applicant.create({:name => "Meagan", :applied_on => Date.today - 5,
                                                         :initial_reply_on => Date.today - 4, :discipline => "developer",
                                                         :skill => "resident", :location => "Chicago"})
    days_since_last_action(applicant).should == 4
  end

  it "formats the date" do
    format_date(Date.parse("20140101")).should == "Jan 1, 2014"
  end

  it "displays the date correctly" do
    display_date(Date.parse("20140101")).to_s.should == "Jan 1, 2014"
  end
end
