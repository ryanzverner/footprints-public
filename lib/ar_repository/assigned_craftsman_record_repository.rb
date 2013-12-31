require 'ar_repository/models/assigned_craftsman_record'
require 'ar_repository/base_repository'

module ArRepository
  class AssignedCraftsmanRecordRepository
    include BaseRepository

    def model_class
      ::AssignedCraftsmanRecord
    end

    def create(attrs = {})
      begin
        assigned_craftsman_record = model_class.new(attrs)
        assigned_craftsman_record.save!
        assigned_craftsman_record
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
        raise Footprints::RecordNotValid.new(assigned_craftsman_record)
      end
    end
  end
end
