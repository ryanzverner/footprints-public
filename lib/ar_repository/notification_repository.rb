require 'ar_repository/models/notification'
require 'ar_repository/base_repository'

module ArRepository
  class NotificationRepository
    include BaseRepository

    def model_class
      ::Notification
    end

    def create(attrs = {})
      begin
        notification = model_class.new(attrs)
        notification.save!
        notification
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
        raise Footprints::RecordNotValid.new(notification)
      end
    end

    def where(query_string, query)
      model_class.where(query_string, query)
    end
  end
end
