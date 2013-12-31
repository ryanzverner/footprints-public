require 'spec_helper'

describe Message do
  let(:applicant)  { Applicant.create({name: "Boo", email: "b@oo.com", applied_on: Date.today,
                                       :discipline => "developer", :skill => "resident", :location => "Chicago"}) }

  let(:attrs) {{
    :title => "This is the title",
    :created_at => Date.today,
    :body => "This is the body",
    :applicant_id => applicant.id
  }}

  before :each do
    @message = Message.create(attrs)
  end

  after :all do
    Applicant.destroy_all
    Message.destroy_all
  end

  it "sets attrs correctly and saves" do
    @message.title.should == attrs[:title]
    @message.body.should == attrs[:body]
  end

  it "associates message with applicant" do
    @message.applicant.should == applicant
  end
end
