require "memory_repository/models/base"
require "active_model"

module MemoryRepository
  class User < MemoryRepository::Base
    data_attributes :login, :created_at, :updated_at, :email,
                    :uid, :provider, :craftsman_id

    def initialize(*args)
      @external_errors = []
      super(*args)
    end
  end
end
