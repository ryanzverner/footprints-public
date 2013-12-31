require 'apprentices/apprentice_list_presenter'

describe ApprenticeListPresenter do
  let(:created_at) { DateTime.new }
  let(:updated_at) { DateTime.new }
  let(:resident) {{:position=> {:created_at => created_at,
                                :id => 15, 
                                :name => "Software Resident", 
                                :updated_at => updated_at},
                   :person=> {:created_at=>"2014-01-01 08:50:00 UTC",                              
                              :id=>115,
                              :first_name=>"F",
                              :last_name=>"Resident",
                              :email=>"f@abcinc.com",
                              :updated_at=>DateTime.parse("2014-09-01")},
                    :created_at=>"2014-01-01 08:50:00 UTC",
                    :start=>DateTime.parse("2014-09-01"),
                    :end=>DateTime.parse("2014-12-01"),
                    :position_id=>15,
                    :id=>205,
                    :person_id=>115,
                    :updated_at=>"2014-01-10 08:50:00 UTC"}}
  let(:raw_residents) { [resident] }

  it "returns a list of presented residents" do
    #expect(ApprenticeListPresenter.new(raw_residents).residents.to eq(:resident)

    residents = ApprenticeListPresenter.new(raw_residents).residents

    resident = residents.first

    expect(resident.name).to eq("F Resident")
    expect(resident.start_date).to eq(DateTime.parse("2014-09-01"))
    expect(resident.end_date).to eq(DateTime.parse("2014-12-01"))
    expect(resident.employment_id).to eq(205)
    expect(resident.person_id).to eq(115)
  end
end
