require 'memory_repository/models/crafter'
require 'memory_repository/base_repository'
require './lib/repository'

module MemoryRepository
  class CrafterRepository
    include BaseRepository

    def new(attrs = {})
      MemoryRepository::Crafter.new(attrs)
    end

    def create(attrs = {})
      crafter = new(attrs)
      if !exisiting_employment_id?(crafter.employment_id) && crafter.valid?
        save(crafter)
      else
        crafter.add_error(:employment_id, 'has already been taken')
        raise Footprints::RecordNotValid.new(crafter)
      end
      crafter
    end

    def find_by_name(name)
      records.values.find { |r| r.name == name }
    end

    def find_by_id(id)
      records.values.find { |r| r.id == id }
    end

    def where(string_query, term)
      matches = records.values.select { |r| r.name.start_with?(term) }
      matches
    end

    def find_by_employment_id(employment_id)
      records.values.find { |r| r.employment_id == employment_id }
    end

    private
    def exisiting_employment_id?(employment_id)
      !find_by_employment_id(employment_id).nil?
    end
  end
end
