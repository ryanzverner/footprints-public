require 'ar_repository/models/assigned_crafter_record'
require 'ar_repository/base_repository'

module ArRepository
  class AssignedCrafterRecordRepository
    include BaseRepository

    def model_class
      ::AssignedCrafterRecord
    end

    def create(attrs = {})
      begin
        assigned_crafter_record = model_class.new(attrs)
        assigned_crafter_record.save!
        assigned_crafter_record
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
        raise Footprints::RecordNotValid.new(assigned_crafter_record)
      end
    end
  end
end
