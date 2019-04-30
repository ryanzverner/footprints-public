require 'spec_helper'
require './lib/ar_repository/assigned_crafter_record_repository'
require './spec/footprints/shared_examples/assigned_crafter_record_examples'

describe ArRepository::AssignedCrafterRecordRepository do
  it_behaves_like "assigned crafter record repository"
end
