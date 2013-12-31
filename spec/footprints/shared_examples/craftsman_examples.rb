shared_examples "craftsman repository" do
  let(:repo) { described_class.new }
  let(:attrs) {{
    :name => "test craftsman",
    :employment_id => "123",
    :status => "test status"
  }}

  let(:craftsman) { repo.create(attrs) }

  def create_craftsman
    repo.create(attrs)
  end

  before do
    repo.destroy_all
  end

  it "creates" do
    craftsman = create_craftsman
    craftsman.should_not be_nil
  end

  it "has an id" do
    craftsman = create_craftsman
    craftsman.id.should_not be_nil
  end

  it "finds by id" do
    craftsman = create_craftsman
    repo.find_by_employment_id(craftsman.employment_id).should == craftsman
  end

  it "finds by name" do
    craftsman = create_craftsman
    repo.find_by_name(attrs[:name]).should == craftsman
  end

  it "finds by employment id" do
    craftsman = create_craftsman
    repo.find_by_employment_id(attrs[:employment_id]).should == craftsman
  end

  it "finds each" do
    craftsman1 = repo.create(:name => "Test One", :employment_id => "123")
    craftsman2 = repo.create(:name => "Test Two", :employment_id => "456")
    craftsmen = []
    repo.find_each do |p|
      craftsmen << p
    end
    craftsmen.size.should == 2
    craftsmen.include?(craftsman1).should be_true
    craftsmen.include?(craftsman2).should be_true
  end

  it "validates presence of unique employment id" do
    repo.create(
      :name => "craftsman",
      :employment_id => "123"
    )
    expect { repo.create(
      :name => "craftsman",
      :employment_id => "123"
    )}.to raise_exception(Footprints::RecordNotValid)
  end

  it "gets the craftsman status" do
    craftsman = create_craftsman
    craftsman.status.should == "test status"
  end

  it "finds by query" do
    craftsman = create_craftsman
    repo.where("name like?", "#{attrs[:name]}").first.should == craftsman
  end
end
