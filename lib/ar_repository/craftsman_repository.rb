require 'ar_repository/models/craftsman'
require 'ar_repository/base_repository'

module ArRepository
  class CraftsmanRepository
    include BaseRepository

    def model_class
      ::Craftsman
    end

    def create(attributes = {})
      begin
        craftsman = model_class.new(attributes)
        craftsman.save!
        craftsman
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => invalid
        raise Footprints::RecordNotValid.new(craftsman)
      end
    end

    def find_by_name(name)
      model_class.find_by_name(name)
    end

    def find_by_id(id)
      model_class.find_by_id(id)
    end

    def find_by_employment_id(employment_id)
      model_class.find_by_employment_id(employment_id)
    end

    def find_by_email(email)
      model_class.find_by_email(email)
    end

    def where_status(query_string)
      if query_string == "Other"
        model_class.where("status != 'Has Apprentice' AND status != 'Seeking Apprentice' AND status != 'New Craftsman' OR status IS NULL")
      else
        model_class.where(:status => query_string).order("name ASC")
      end
    end

    def where(query_string, query)
      model_class.where(query_string, query)
    end

    def unscoped
      model_class.unscoped
    end

    def archived
      model_class.archived
    end
  end
end
