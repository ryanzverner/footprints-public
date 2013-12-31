require 'ar_repository/models/message'
require 'ar_repository/base_repository'

module ArRepository
  class MessageRepository
    include BaseRepository

    def model_class
      ::Message
    end
  end
end
