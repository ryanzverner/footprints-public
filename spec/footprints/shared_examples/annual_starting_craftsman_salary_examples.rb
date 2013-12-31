shared_examples "annual starting craftsman salary" do
  let(:repo) { described_class.new }

  let(:salary) {{
    :location => "Chicago",
    :amount => 100000000000
  }}

  def create_salary
    repo.create(salary)
  end

  before do
    repo.destroy_all
  end

  it "creates" do
    salary_record = create_salary
    expect(salary_record).not_to be_nil
  end

  it "has an id" do
    salary_record = create_salary
    expect(salary_record.id).not_to be_nil
  end

  it "finds by location" do
    salary_record = create_salary
    expect(repo.find_by_location(salary[:location])).to eq salary_record
  end

end
