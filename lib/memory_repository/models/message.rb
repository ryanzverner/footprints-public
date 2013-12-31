require "memory_repository/models/base"
require "active_model"

module MemoryRepository
  class Message < MemoryRepository::Base
    data_attributes :applicant_id, :body, :created_at, :title, :updated_at
  end
end
