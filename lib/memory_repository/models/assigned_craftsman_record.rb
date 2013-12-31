require "memory_repository/models/base"
require "active_model"

module MemoryRepository
  class AssignedCraftsmanRecord < MemoryRepository::Base
    data_attributes :craftsman_id, :applicant_id, :current

    def initialize(*args)
      @external_errors = []
      super(*args)
    end

    def add_error(*args)
      @external_errors << args
    end
  end
end
