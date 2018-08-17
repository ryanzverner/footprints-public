require 'spec_helper'
require './lib/reporting/real_data_parser'

describe RealDataParser do 
  let(:now)              { Time.now.utc }
  let(:start_date)       { Time.parse("2014-08-01") }

  context 'craftsmen' do

    let(:craftsmen_mock_data) { [
      Craftsman.new(id: 1, name: "Tom Johannsen", status: nil, employment_id: 0, uid: nil, email: "tom.johannsen@abcinc.com", location: "Chicago", archived: false, position: nil, seeking: true, skill: 2, has_apprentice: false, unavailable_until: nil),
      Craftsman.new(id: 2, name: "Douglas Kles", status: nil, employment_id: 1, uid: nil, email: "douglas.kles@abcinc.com", location: "Chicago", archived: false, position: nil, seeking: true, skill: 2, has_apprentice: false, unavailable_until:nil),
      Craftsman.new(id: 3, name: "Alan Abernathy", status: nil, employment_id: 2, uid: nil, email: "alan.abernathy@abcinc.com", location: "Chicago", archived: false, position: nil, seeking: true, skill: 1, has_apprentice: false, unavailable_until: nil),
      Craftsman.new()
    ]}

    let(:apprentice_mock_data) { [
      Apprentice.new(id: 2, created_at: "2018-08-10 21:20:16", updated_at: "2018-08-10 21:20:16", name: "Art Blakey", applied_on: nil, email: "art.blakey@gmail.com", hired: nil, location: "Chicago", archived: nil, position: "developer", start_date: nil, end_date: nil, mentor: nil),

      Apprentice.new(id: 3, created_at: "2018-08-10 21:21:29", updated_at: "2018-08-10 21:21:29", name: "Dave Brubeck", applied_on: nil, email: "dave.brubeck@gmail.com", hired: nil,location: "Chicago", archived: nil, position: "developer", start_date: "2018-08-09", end_date: "2018-11-11", mentor: "Charlie Batch"),

      Apprentice.new(id: 4, created_at: "2018-08-10 21:22:24", updated_at: "2018-08-10 21:22:24", name: "Bill Evans", applied_on: nil, email: "bill.evans@gmail.com", hired: nil, location: "Los Angeles", archived: nil, position: "designer", start_date: "2018-08-10", end_date: "2018-11-11", mentor: "Russell Baker (London Director)")
    ]}

    context '#software_apprentices_for(month, year)' do
      it 'returns 0 when there are no apprentices for the given month' do
        parser = RealDataParser.new(craftsmen_mock_data, apprentice_mock_data)

        result = {"Software Apprentices" => 0,
                  "UX Apprentices" => 0 }

        expect(parser.apprentices_for(8, 2014)).to eq(result)
      end
    end
  end
end