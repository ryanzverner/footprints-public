require 'spec_helper'
require './lib/memory_repository/applicant_repository'
require './lib/memory_repository/crafter_repository'
require './lib/memory_repository/user_repository'
require './lib/memory_repository/message_repository'

describe MemoryRepository do
  it "has an applicant repo" do
    MemoryRepository.applicant.should be_a MemoryRepository::ApplicantRepository
  end

  it "has a crafter repo" do
    MemoryRepository.crafter.should be_a MemoryRepository::CrafterRepository
  end

  it "has a user repo" do
    MemoryRepository.user.should be_a MemoryRepository::UserRepository
  end

  it "has a message repo" do
    MemoryRepository.message.should be_a MemoryRepository::MessageRepository
  end
end
