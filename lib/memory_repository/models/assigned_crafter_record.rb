require "memory_repository/models/base"
require "active_model"

module MemoryRepository
  class AssignedCrafterRecord < MemoryRepository::Base
    data_attributes :crafter_id, :applicant_id, :current

    def initialize(*args)
      @external_errors = []
      super(*args)
    end

    def add_error(*args)
      @external_errors << args
    end
  end
end
