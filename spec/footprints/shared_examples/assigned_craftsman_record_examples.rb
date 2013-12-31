shared_examples "assigned craftsman record repository" do
  let(:repo) { described_class.new }
  let(:applicant) { Applicant.create(:name => "A Applicant",
                                     :applied_on => Date.current)}
  let(:craftsman) { Craftsman.create(:name => "A Craftsman",
                                     :employment_id => "0") }

  let(:assigned_craftsman_record) {{
    :applicant_id => applicant.id,
    :craftsman_id => craftsman.id
  }}

  def create_assigned_craftsman_record
    repo.create(assigned_craftsman_record)
  end

  before do
    repo.destroy_all
  end

  it "creates" do
    record = create_assigned_craftsman_record
    expect(record).not_to be_nil
  end

  it "has an id" do
    record = create_assigned_craftsman_record
    expect(record.id).not_to be_nil
  end
end
