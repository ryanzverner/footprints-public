require 'spec_helper'
require './lib/memory_repository/user_repository'
require './spec/footprints/shared_examples/user_examples'

describe MemoryRepository::UserRepository do
  it_behaves_like "user repository"
end
