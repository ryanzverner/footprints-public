shared_examples "note repository" do
  let(:repo) { described_class.new }
  let(:applicant) { Applicant.create(:name => "A Applicant",
                                     :applied_on => Date.current)}
  let(:crafter) { Crafter.create(:name => "A Crafter",
                                     :employment_id => "0") }
  let(:note) {{
    :body => "Test",
    :applicant_id => applicant.id,
    :crafter_id => crafter.id
  }}

  def create_note
    repo.create(note)
  end

  before do
    repo.destroy_all
  end

  it "creates" do
    note = create_note
    expect(note).not_to be_nil
  end

  it "has an id" do
    note = create_note
    expect(note.id).not_to be_nil
  end

  it "finds by applicant_id" do
    note = create_note
    expect(repo.find_by_applicant_id(applicant.id)).to eq note
  end

end
