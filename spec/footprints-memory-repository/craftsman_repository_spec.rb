require 'spec_helper'
require './lib/memory_repository/applicant_repository'
require './spec/footprints/shared_examples/crafter_examples'

describe MemoryRepository::CrafterRepository do
  it_behaves_like "crafter repository"

  let(:repo) { described_class.new }
   let(:attrs) {{
    :name => "test crafter",
    :status => "test status",
    :employment_id => "123"
  }}

  let(:crafter) { repo.create(attrs) }

  it "orders crafter asc" do
    crafter
    test = repo.create(:name => "abc", :status => "ok", :employment_id => "789")
    repo.order("name ASC").first.should == test.id
  end

  it "orders crafter desc" do
    repo.create(attrs)
    test = repo.create(:name => "xyz", :status => "ok", :employment_id => "456")
    repo.order("name DESC").first.should == test.id
  end
end


