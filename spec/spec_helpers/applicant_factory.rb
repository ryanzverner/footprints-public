require 'spec_helper'

module SpecHelpers
  class ApplicantFactory
    def create(attrs = {})
      Footprints::Repository.applicant.create(build_attrs(attrs))
    end

    private

    def build_attrs(attrs)
      _first_name = first_name
      _last_name  = last_name
      attrs.merge({:name      => "#{_first_name} #{_last_name}",
                   :email      => email(_first_name, _last_name),
                   :applied_on => Date.yesterday,
                   :skill => attrs[:skill] || skill,
                   :location => attrs[:location] || location,
                   :discipline => attrs[:discipline] || discipline})
    end

    def first_name
      ["Bob", "Holly", "Todd", "Phyllis", "Creed", "Angela", "Andy"].sample
    end

    def last_name
      ["Dwyer", "Scarn", "Packer", "Dylan", "Bratton", "Schrute", "Murray"].sample
    end

    def email(_first_name, _last_name)
      count_to_guarantee_email_uniqueness = Footprints::Repository.applicant.all.count
      email = "#{_first_name}-#{_last_name}-#{count_to_guarantee_email_uniqueness}@dundermifflin.com"
    end

    def skill
      ["student", "resident"].sample
    end

    def location
      ["Chicago", "London"].sample
    end

    def discipline
      ["developer", "designer"].sample
    end

  end
end
