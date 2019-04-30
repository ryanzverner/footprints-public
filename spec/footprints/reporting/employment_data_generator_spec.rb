require './lib/reporting/employment_data_generator'
require './lib/reporting/data_parser'
require './lib/warehouse/fake_api'

describe EmploymentDataGenerator do
  let(:employment_data)  { 
    [
      { :start => Time.parse("2014-09-01"), 
        :end => Time.parse("2014-12-30"), 
        :position => { 
          :name => "Software Resident" },
        :person_id => 32 
    },
                            
    { :start => Time.parse("2014-09-01"), 
      :end => Time.parse("2015-09-30"), 
      :position => { 
        :name => "UX Resident" },
      :person_id => 33 },

      { :start => Time.parse("2014-12-31"), 
        :end => Time.parse("2015-12-30"), 
        :position => { 
          :name => "Software Crafter" },
        :person_id => 32 
    },
                            
    { :start => Time.parse("2015-09-31"), 
      :end => Time.parse("2016-09-30"), 
      :position => { 
        :name => "UX Crafter" },
      :person_id => 33 }
    ]
  }

  let(:apprenticeships) {
    Warehouse::FakeAPIData.apprenticeships
  }

  it 'generates the data for a given month' do
    parser = DataParser.new(employment_data, apprenticeships)
    generator = EmploymentDataGenerator.new(parser)

    expect(generator.generate_data_for("Dec 2014")).to eq({
      "Software Crafters" => 0, "UX Crafters" => 0,
      "Software Residents" => 1, "UX Residents" => 1,
      "Finishing Software Residents" => 1, "Finishing UX Residents" => 0,
      "Student Apprentices" => 1
    })
  end

  it 'finishing apprentices count as crafters starting next month' do
    parser = DataParser.new(employment_data, apprenticeships)
    generator = EmploymentDataGenerator.new(parser)

    generator.generate_data_for("Dec 2014")

    expect(generator.generate_data_for("Jan 2015")).to eq({
      "Software Crafters" => 1, "UX Crafters" => 0,
      "Software Residents" => 0, "UX Residents" => 1,
      "Finishing Software Residents" => 0, "Finishing UX Residents" => 0,
      "Student Apprentices" => 0
    })
  end
end
