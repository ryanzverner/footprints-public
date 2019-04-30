shared_examples "crafter repository" do
  let(:repo) { described_class.new }
  let(:attrs) {{
    :name => "test crafter",
    :employment_id => "123",
    :status => "test status"
  }}

  let(:crafter) { repo.create(attrs) }

  def create_crafter
    repo.create(attrs)
  end

  before do
    repo.destroy_all
  end

  it "creates" do
    crafter = create_crafter
    crafter.should_not be_nil
  end

  it "has an id" do
    crafter = create_crafter
    crafter.id.should_not be_nil
  end

  it "finds by id" do
    crafter = create_crafter
    repo.find_by_employment_id(crafter.employment_id).should == crafter
  end

  it "finds by name" do
    crafter = create_crafter
    repo.find_by_name(attrs[:name]).should == crafter
  end

  it "finds by employment id" do
    crafter = create_crafter
    repo.find_by_employment_id(attrs[:employment_id]).should == crafter
  end

  it "finds each" do
    crafter1 = repo.create(:name => "Test One", :employment_id => "123")
    crafter2 = repo.create(:name => "Test Two", :employment_id => "456")
    crafters = []
    repo.find_each do |p|
      crafters << p
    end
    crafters.size.should == 2
    crafters.include?(crafter1).should be_true
    crafters.include?(crafter2).should be_true
  end

  it "validates presence of unique employment id" do
    repo.create(
      :name => "crafter",
      :employment_id => "123"
    )
    expect { repo.create(
      :name => "crafter",
      :employment_id => "123"
    )}.to raise_exception(Footprints::RecordNotValid)
  end

  it "gets the crafter status" do
    crafter = create_crafter
    crafter.status.should == "test status"
  end

  it "finds by query" do
    crafter = create_crafter
    repo.where("name like?", "#{attrs[:name]}").first.should == crafter
  end
end
