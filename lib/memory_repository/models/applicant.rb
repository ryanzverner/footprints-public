require "memory_repository/models/base"
require "active_model"

module MemoryRepository
  class Applicant < MemoryRepository::Base
    data_attributes :name, :email, :applied_on, :initial_reply_on, :sent_challenge_on, :completed_challenge_on, :reviewed_on, :offered_on, :decision_made_on, :hired, :codeschool, :college_degree, :cs_degree, :worked_as_dev, :assigned_craftsman, :additional_notes, :code_submission, :state, :craftsman_id, :slug, :archived

    include ActiveModel::Validations

    validates_with DateValidator
    validates_with UrlValidator
    validates :name, presence: true
    validates :applied_on, presence: true

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
