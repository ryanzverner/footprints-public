require 'memory_repository/models/assigned_craftsman_record'
require 'memory_repository/base_repository'

module MemoryRepository
  class AssignedCraftsmanRecordRepository
    include BaseRepository

    def model_class
      ::AssignedCraftsmanRecord
    end

    def new(attrs = {})
      model_class.new(attrs)
    end

    def create(attrs = {})
      save(new(attrs))
    end
  end
end
