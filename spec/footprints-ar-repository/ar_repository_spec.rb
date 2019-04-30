require "spec_helper"
require "./lib/ar_repository/ar_repository"

describe ArRepository do
  it "has an applicant repo" do
    ArRepository.applicant.should be_a ArRepository::ApplicantRepository
  end

  it "has a crafter repo" do
    ArRepository.crafter.should be_a ArRepository::CrafterRepository
  end

  it "has a message repo" do
    ArRepository.message.should be_a ArRepository::MessageRepository
  end

  it "has a user repo" do
    ArRepository.user.should be_a ArRepository::UserRepository
  end
end
