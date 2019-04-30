shared_examples "assigned crafter record repository" do
  let(:repo) { described_class.new }
  let(:applicant) { Applicant.create(:name => "A Applicant",
                                     :applied_on => Date.current)}
  let(:crafter) { Crafter.create(:name => "A Crafter",
                                     :employment_id => "0") }

  let(:assigned_crafter_record) {{
    :applicant_id => applicant.id,
    :crafter_id => crafter.id
  }}

  def create_assigned_crafter_record
    repo.create(assigned_crafter_record)
  end

  before do
    repo.destroy_all
  end

  it "creates" do
    record = create_assigned_crafter_record
    expect(record).not_to be_nil
  end

  it "has an id" do
    record = create_assigned_crafter_record
    expect(record.id).not_to be_nil
  end
end
