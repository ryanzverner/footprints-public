require 'active_support/core_ext/date'
require 'warehouse/identifiers'
require 'repository'

module Warehouse
  class EmploymentPost
    def initialize(api)
      @warehouse = api
    end

    def add_resident!(applicant)
      person_id = add_person!(applicant)
      add_resident_employment!(applicant, person_id)
      add_craftsman!(applicant, person_id)
    end

    def add_student!(applicant)
      person_id = add_person!(applicant)
      craftsman_id = find_craftsman_person_id(applicant.mentor)
      add_student_apprentice!(applicant, person_id, craftsman_id)
    end

    private

    attr_reader :warehouse

    def find_craftsman_person_id(mentor)
      record = Footprints::Repository.craftsman.find_by_name(mentor)
      employment_id = record[:employment_id]
      person_id = warehouse.find_employment_by_id(employment_id)[:person_id]
    end

    def add_resident_employment!(applicant, person_id)
      warehouse.create_employment!(
        :person_id => person_id,
        :position_name => find_position_name(applicant.discipline, APPRENTICE_POSITION_NAMES),
        :start => applicant.start_date,
        :end => applicant.end_date)
    end

    def add_craftsman!(applicant, person_id)
      warehouse.create_employment!(
        :person_id => person_id,
        :position_name => find_position_name(applicant.discipline, CRAFTSMAN_POSITION_NAMES),
        :start => next_monday(applicant.end_date),
        :end => nil)
    end

    def add_student_apprentice!(applicant, person_id, mentor_id)
      warehouse.create_apprenticeship!(
        :person_id => person_id,
        :skill_level => "student",
        :start => applicant.start_date,
        :end => applicant.end_date,
        :mentorships => [{
          :person_id => mentor_id,
          :start => applicant.start_date,
          :end => applicant.end_date
        }])
    end

    def add_person!(applicant)
      warehouse.create_person!(
        :first_name => applicant.first_name,
        :last_name => applicant.last_name,
        :email => applicant.email
      )
    end

    def find_position_name(position_name, warehouse_names)
      warehouse_names[position_name.downcase.to_sym]
    end

    def next_monday(date)
      date.next_week.at_beginning_of_week
    end


  end
end
