require 'spec_helper'
require './lib/memory_repository/assigned_crafter_record_repository'
require './spec/footprints/shared_examples/assigned_crafter_record_examples'

describe MemoryRepository::AssignedCrafterRecordRepository do
  it_behaves_like "assigned crafter record repository"
end
