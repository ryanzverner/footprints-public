require 'apprentices/student_list_presenter'
require 'warehouse/fake_api'

RSpec.describe StudentListPresenter do
  let(:raw_apprentices) {
    [{
      :id => 1,
      :person_id => 1,
      :person => {
        :id => 1,
        :first_name => "john",
        :last_name => "doe",
        :email => "johndoe@example.com"
      },
      :start => DateTime.parse("September 1 2014"),
      :end => DateTime.parse("September 30 2014"),
      :mentorships => [
        {
          :person_id => 10,
          :person => {
            :id => 10,
            :first_name => "jane",
            :last_name => "doe",
            :email => "janedoe@example.com"
          },
          :start => DateTime.parse("September 1 2014"),
          :end => DateTime.parse("September 30 2014")
        }, {
          :person_id => 11,
          :person => {
            :id => 11,
            :first_name => "bob",
            :last_name => "saget",
            :email => "bogsaget@example.com"
          },
          :start => DateTime.parse("September 1 2014"),
          :end => DateTime.parse("September 30 2014")
        }, {
          :person_id => 11,
          :person => {
            :id => 11,
            :first_name => "Uncle",
            :last_name => "Bob",
            :email => "unclebob@example.com"
          },
          :start => DateTime.parse("September 1 2014"),
          :end => DateTime.parse("September 30 2014")
        }
      ]
    }]
  }

  subject { described_class.new(raw_apprentices).students.first }

  it "presents apprentices names" do
    expect(subject.name).to eq("John Doe")
  end

  it "presents apprentices emails" do
    expect(subject.email).to eq("johndoe@example.com")
  end

  it "presents apprentices start dates" do
    expect(subject.start_date).to eq(DateTime.parse("September 1 2014"))
  end

  it "presents apprentices end dates" do
    expect(subject.end_date).to eq(DateTime.parse("September 30 2014"))
  end

  it "presents a students mentors" do
    expect(subject.mentor_names).to eq("Jane Doe, Bob Saget, and Uncle Bob")
  end
end
