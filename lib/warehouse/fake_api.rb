module Warehouse
  class FakeAPIData
    def self.apprenticeships
      @apprenticeships ||= [
        {
          :id => 1,
          :person_id => 1,
          :start => DateTime.parse("September 1 2014"),
          :end => DateTime.parse("September 30 2014"),
          :skill_level => "resident",
          :mentorships => [
            {
              :person_id => 10,
              :start => DateTime.parse("September 1 2014"),
              :end => DateTime.parse("September 30 2014")
            }
          ]
        }, {
          :id => 1,
          :person_id => 1,
          :start => DateTime.parse("September 1 2014"),
          :end => DateTime.parse("September 30 2014"),
          :skill_level => "resident",
          :mentorships => [
            {
              :person_id => 10,
              :start => DateTime.parse("September 1 2014"),
              :end => DateTime.parse("September 30 2014")
            }
          ]
        }, {
          :id => 2,
          :person_id => 2,
          :start => DateTime.parse("December 1 2014"),
          :end => DateTime.parse("December 30 2014"),
          :skill_level => "resident",
          :mentorships => [
            {
              :person_id => 10,
              :start => DateTime.parse("December 1 2014"),
              :end => DateTime.parse("December 30 2014")
            }
          ]
        }, {
          :id => 3,
          :person_id => 3,
          :person => {
            :first_name => "john",
            :last_name => "doe",
            :email => "johndoe@footprints.com"
          },
          :start => DateTime.parse("December 1 2014"),
          :end => DateTime.parse("December 30 2014"),
          :skill_level => "student",
          :mentorships => [
            {
              :person_id => 10,
              :person => {
                :first_name => "jane",
                :last_name => "doe",
                :email => "janedoe@footprints.com"
              },
              :start => DateTime.parse("December 1 2014"),
              :end => DateTime.parse("December 30 2014")
            }, {
              :person_id => 11,
              :person => {
                :first_name => "bob",
                :last_name => "saget",
                :email => "the_other_uncle_bob@footprints.com"
              },
              :start => DateTime.parse("December 1 2014"),
              :end => DateTime.parse("December 30 2014")
            }, {
              :person_id => 12,
              :person => {
                :first_name => "uncle",
                :last_name => "bob",
                :email => "uncle_bob@footprints.com"
              },
              :start => DateTime.parse("December 1 2014"),
              :end => DateTime.parse("December 30 2014")
            }
          ]
        }
      ]
    end

    def self.data
      @created_at ||= Time.parse("2014-01-01 08:50:00 UTC")
      @updated_at ||= Time.parse("2014-01-10 08:50:00 UTC")
      @start_date ||= Time.parse("#{Time.now.month}/#{Time.now.year}")
      @employments ||= [
        {
          :position =>  {
            :created_at => @created_at,
            :id => 10,
            :name => "Software Craftsman",
            :updated_at => @updated_at
          },
          :person =>  {
            :created_at => @created_at,
            :id => 110,
            :first_name => "A",
            :last_name => "Craftsman",
            :email => "a@footprints.com",
            :updated_at => @updated_at
          },
          :created_at => @created_at,
          :start => @start_date,
          :end => nil,
          :position_id => 10,
          :id => 200,
          :person_id => 110,
          :updated_at => @updated_at
        },
        {
          :position =>  {
            :created_at => @created_at,
            :id => 11,
            :name => "Software Craftsman",
            :updated_at => @updated_at
          },
          :person =>  {
            :created_at => @created_at,
            :id => 111,
            :first_name => "B",
            :last_name => "Craftsman",
            :email => "b@footprints.com",
            :updated_at => @updated_at
          },
          :created_at => @created_at,
          :start => @start_date,
          :end => nil,
          :position_id => 11,
          :id => 201,
          :person_id => 111,
          :updated_at => @updated_at
        },
        {
          :position =>  {
            :created_at => @created_at,
            :id => 12,
            :name => "Software Craftsman",
            :updated_at => @updated_at
          },
          :person =>  {
            :created_at => @created_at,
            :id => 112,
            :first_name => "C",
            :last_name => "Craftsman",
            :email => "c@footprints.com",
            :updated_at => @updated_at
          },
          :created_at => @created_at,
          :start => @start_date,
          :end => nil,
          :position_id => 12,
          :id => 202,
          :person_id => 112,
          :updated_at => @updated_at
        },
        {
          :position =>  {
            :created_at => @created_at,
            :id => 13,
            :name => "UX Craftsman",
            :updated_at => @updated_at
          },
          :person =>  {
            :created_at => @created_at,
            :id => 113,
            :first_name => "D",
            :last_name => "Craftsman",
            :email => "d@footprints.com",
            :updated_at => @updated_at
          },
          :created_at => @created_at,
          :start => @start_date,
          :end => nil,
          :position_id => 13,
          :id => 203,
          :person_id => 113,
          :updated_at => @updated_at
        },
        {
          :position =>  {
            :created_at => @created_at,
            :id => 14,
            :name => "UX Craftsman",
            :updated_at => @updated_at
          },
          :person =>  {
            :created_at => @created_at,
            :id => 114,
            :first_name => "E",
            :last_name => "Craftsman",
            :email => "e@footprints.com",
            :updated_at => @updated_at
          },
          :created_at => @created_at,
          :start => @start_date,
          :end => nil,
          :position_id => 14,
          :id => 204,
          :person_id => 114,
          :updated_at => @updated_at
        },
        {
          :position =>  {
            :created_at => @created_at,
            :id => 15,
            :name => "Software Resident",
            :updated_at => @updated_at
          },
          :person =>  {
            :created_at => @created_at,
            :id => 115,
            :first_name => "F",
            :last_name => "Resident",
            :email => "f@footprints.com",
            :updated_at => @updated_at
          },
          :created_at => @created_at,
          :start => @start_date,
          :end => nil,
          :position_id => 15,
          :id => 205,
          :person_id => 115,
          :updated_at => @updated_at
        },
        {
          :position =>  {
            :created_at => @created_at,
            :id => 16,
            :name => "Software Resident",
            :updated_at => @updated_at
          },
          :person =>  {
            :created_at => @created_at,
            :id => 116,
            :first_name => "G",
            :last_name => "Resident",
            :email => "g@footprints.com",
            :updated_at => @updated_at
          },
          :created_at => @created_at,
          :start => @start_date,
          :end => add_n_months(@start_date, 2),
          :position_id => 16,
          :id => 206,
          :person_id => 116,
          :updated_at => @updated_at
        },
        {
          :position =>  {
            :created_at => @created_at,
            :id => 17,
            :name => "UX Resident",
            :updated_at => @updated_at
          },
          :person =>  {
            :created_at => @created_at,
            :id => 117,
            :first_name => "H",
            :last_name => "Resident",
            :email => "h@footprints.com",
            :updated_at => @updated_at
          },
          :created_at => @created_at,
          :start => @start_date,
          :end => add_n_months(@start_date, 11),
          :position_id => 17,
          :id => 207,
          :person_id => 117,
          :updated_at => @updated_at
        },
        {
          :position =>  {
            :created_at => @created_at,
            :id => 18,
            :name => "UX Resident",
            :updated_at => @updated_at
          },
          :person =>  {
            :created_at => @created_at,
            :id => 118,
            :first_name => "I",
            :last_name => "Resident",
            :email => "i@footprints.com",
            :updated_at => @updated_at
          },
          :created_at => @created_at,
          :start => @start_date,
          :end => nil,
          :position_id => 18,
          :id => 208,
          :person_id => 118,
          :updated_at => @updated_at
        },
        {
          :position =>  {
            :created_at => @created_at,
            :id => 18,
            :name => "UX Craftsman",
            :updated_at => @updated_at
          },
          :person =>  {
            :created_at => @created_at,
            :id => 118,
            :first_name => "I",
            :last_name => "Resident",
            :email => "i@footprints.com",
            :updated_at => @updated_at
          },
          :created_at => @created_at,
          :start => @start_date,
          :end => nil,
          :position_id => 18,
          :id => 225,
          :person_id => 118,
          :updated_at => @updated_at
        },
      ]
    end

    def self.add_n_months(time, months)
      future_date = time.to_date >> months

      future_date.to_time.utc
    end
  end

  class FakeAPI
    attr_reader :created_at, :updated_at, :start_date

    def initialize(client)
    end

    def find_all_employments
      FakeAPIData.data
    end

    def find_employment_by_id(id)
      find_all_employments.select { |e|
        e[:id] == id
      }.first
    end

    def find_all_apprenticeships
      FakeAPIData.apprenticeships
    end

    def update_employment!(id, options)
      employment = find_employment_by_id(id)
      employment[:start] = options[:start] if !options[:start].nil?
      employment[:end] = options[:end] if !options[:end].nil?
      employment[:position_name] = options[:position_name] if !options[:position_name].nil?
      employment[:person_id] = options[:person_id] if !options[:person_id].nil?
      return nil
    end
  end
end
