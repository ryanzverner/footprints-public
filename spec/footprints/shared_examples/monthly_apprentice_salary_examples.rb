shared_examples "monthly apprentice salary" do
  let(:repo) { described_class.new }

  let(:salary1) {{
    :duration => 6,
    :location => "Chicago",
    :amount => 600
  }}

  let(:salary2) {{
    :duration => 7,
    :location => "Chicago",
    :amount   => 500
  }}

  let(:salary3) {{
    :duration => 8,
    :location => "Chicago",
    :amount  => 500
  }}


  def create_salary(data)
    repo.create(data)
  end

  before do
    repo.destroy_all
  end

  it "creates" do
    salary_record = create_salary(salary1)
    expect(salary_record).not_to be_nil
  end

  it "has an id" do
    salary_record = create_salary(salary1)
    expect(salary_record.id).not_to be_nil
  end

  it "finds by duration at location" do
    salary_record = create_salary(salary1)
    expect(repo.find_by_duration_at_location(salary1[:duration], salary1[:location])).to eq salary_record
  end

 it "finds all durations by location" do
    create_salary(salary1)
    create_salary(salary2)
    create_salary(salary3)
    expect(repo.find_all_durations_by_location("Chicago")).to eq([6,7,8])
  end
end
