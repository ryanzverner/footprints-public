require 'spec_helper'

module SpecHelpers
  class CraftsmanFactory
    def initialize
      @employment_id = 100
    end

    def create(attrs = {})
      Footprints::Repository.craftsman.create(build_attrs(attrs))
    end

    private

    def build_attrs(attrs)
      _first_name = first_name
      _last_name  = last_name
      _employment_id = (@employment_id += 1)
      name = attrs[:name] || "#{_first_name} #{_last_name} #{_employment_id}"
      attrs.merge({:name          => name,
                   :email         => email(_first_name, _last_name, _employment_id),
                   :employment_id => _employment_id})
    end

    def first_name
      ["Michael", "Toby", "Kelly", "Ryan", "Meredith", "Kevin", "Oscar"].shuffle.pop
    end

    def last_name
      ["Palmer", "Scott", "Vance", "Kapuur", "Flenderson", "Martinez", "Hannah"].shuffle.pop
    end

    def email(_first_name, _last_name, _employment_id)
      "#{_first_name}.#{_last_name}-#{_employment_id}@dundermifflin.com"
    end
  end
end
