require "memory_repository/models/base"
require "active_model"

module MemoryRepository
  class Note < MemoryRepository::Base
    data_attributes :body, :applicant_id, :craftsman_id
    include ActiveModel::Validations

    validates_presence_of :body

    validate do
      @external_errors.each { |error| errors.add_error *error }
      true
    end

    def initialize(*args)
      @external_errors = []
      super(*args)
    end

    def add_error(*args)
      @external_errors << args
    end

  end
end
