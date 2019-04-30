require './lib/memory_repository/applicant_repository'
require './lib/memory_repository/crafter_repository'
require './lib/memory_repository/user_repository'
require './lib/memory_repository/assigned_crafter_record_repository'
require './lib/memory_repository/message_repository'

module MemoryRepository
  def self.applicant
    @applicant_repo ||= ApplicantRepository.new
  end

  def self.crafter
    @crafter_repo ||= CrafterRepository.new
  end

  def self.user
    @user_repo ||= UserRepository.new
  end

  def self.message
    @message_repo ||= MessageRepository.new
  end

  def self.assigned_crafter_record
    @assigned_crafter_record ||= AssignedCrafterRecordRepository.new
  end
end
