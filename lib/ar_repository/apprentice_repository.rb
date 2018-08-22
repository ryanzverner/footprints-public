require 'ar_repository/models/apprentice'
require 'ar_repository/base_repository'

module ArRepository
  class ApprenticeRepository
    include BaseRepository

    def model_class
      ::Apprentice
    end

    def create(attributes = {})
      begin
        apprentice = model_class.new(attributes)
        apprentice.save!
        apprentice
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => invalid
        raise Footprints::RecordNotValid.new(apprentice)
      end
    end

    def where(query_string, query)
      model_class.where(query_string, query)
    end

  end
end