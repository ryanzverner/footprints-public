require 'spec_helper'
require './lib/ar_repository/applicant_repository'
require './spec/footprints/shared_examples/applicant_examples'

describe ArRepository::ApplicantRepository do
  it_behaves_like "applicant repository"
end
