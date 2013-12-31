require "memory_repository/models/base"
require "active_model"

module MemoryRepository
  class Craftsman < MemoryRepository::Base
    data_attributes :name, :status, :employment_id

    include ActiveModel::Validations

    validates :employment_id, presence: true

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
