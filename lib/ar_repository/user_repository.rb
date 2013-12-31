require 'ar_repository/models/user'
require 'ar_repository/base_repository'

module ArRepository
  class UserRepository
    include BaseRepository

    def model_class
      ::User
    end

    def create(attributes = {})
      user = model_class.new(attributes)
      user.save!
      user
    end

    def find_by_login(login)
      model_class.find_by_login(login)
    end

    def find_by_email(email)
      model_class.find_by_email(email)
    end

    def find_by_id(id)
      model_class.find_by_id(id)
    end

    def find_by_uid(uid)
      model_class.find_by_uid(uid)
    end

    def find_or_create_by_auth_hash(hash)
      model_class.find_or_create_by_auth_hash(hash)
    end
  end
end
