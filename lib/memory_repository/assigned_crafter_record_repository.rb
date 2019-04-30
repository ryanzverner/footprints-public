require 'memory_repository/models/assigned_crafter_record'
require 'memory_repository/base_repository'

module MemoryRepository
  class AssignedCrafterRecordRepository
    include BaseRepository

    def model_class
      ::AssignedCrafterRecord
    end

    def new(attrs = {})
      model_class.new(attrs)
    end

    def create(attrs = {})
      save(new(attrs))
    end
  end
end
