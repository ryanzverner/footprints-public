require 'ar_repository/models/note'
require 'ar_repository/base_repository'

module ArRepository
  class NoteRepository
    include BaseRepository

    def model_class
      ::Note
    end

    def create(attributes = {})
      begin
        note = model_class.new(attributes)
        note.save!
        note
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => invalid
        raise Footprints::RecordNotValid.new(note)
      end
    end

    def find_by_applicant_id(applicant_id)
      model_class.find_by_applicant_id(applicant_id)
    end

  end
end
