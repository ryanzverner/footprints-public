require 'spec_helper'
require "./lib/ar_repository/crafter_repository"
require "./spec/footprints/shared_examples/crafter_examples.rb"

describe ArRepository::CrafterRepository do
  it_behaves_like "crafter repository"

  let(:repo) { described_class.new }
  let(:attrs) {{
    :name => "test crafter",
    :status => "test status"
  }}

  let(:crafter) { repo.create(attrs) }

  it "orders crafter" do
    test = repo.create(:name => "abc", :status => "ok", :employment_id => "123")
    repo.order("name ASC").first.should == test
  end
end
