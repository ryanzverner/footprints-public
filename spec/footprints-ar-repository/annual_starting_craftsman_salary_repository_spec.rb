require 'spec_helper'
require './lib/ar_repository/annual_starting_crafter_salary_repository'
require './spec/footprints/shared_examples/annual_starting_crafter_salary_examples'

describe ArRepository::AnnualStartingCrafterSalaryRepository do
  it_behaves_like "annual starting crafter salary"
end
