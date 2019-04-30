module Footprints
  class RecordNotFound < RuntimeError
    attr_reader :base

    def initialize(base = nil)
      @base = base
    end
  end

  class RecordNotValid < RuntimeError
    attr_reader :record

    def initialize(record)
      @record = record
      Rails.logger.error(record.errors.full_messages)
    end
  end

  class Repository
    def self.register_repo(repo)
      @repo = repo
    end

    def self.applicant
      repo.applicant
    end
    
    def self.apprentice
      repo.apprentice
    end

    def self.crafter
      repo.crafter
    end

    def self.user
      repo.user
    end

    def self.message
      repo.message
    end

    def self.notes
      repo.notes
    end

    def self.repo
      @repo
    end

    def self.assigned_crafter_record
      repo.assigned_crafter_record
    end

    def self.monthly_apprentice_salary
      repo.monthly_apprentice_salary
    end

    def self.annual_starting_crafter_salary
      repo.annual_starting_crafter_salary
    end

  end
end
