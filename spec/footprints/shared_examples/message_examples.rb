shared_examples "message repository" do
  let(:repo) { described_class.new }
  let(:applicant) { Footprints::Repository.applicant.create(:name => "Applicant", :applied_on => Date.today, :email => "email@email.com",
                                                            :discipline => "developer", :skill => "resident", :location => "Chicago") }

  let(:attrs) {{
    :title => "This is the title",
    :created_at => Date.today,
    :body => "This is the body",
    :applicant_id => applicant.id
  }}

  def create_message
    repo.create(attrs)
  end

  before do
    repo.destroy_all
  end

  it "creates" do
    message = create_message
    message.should_not be_nil
  end

  it "has an id" do
    message = create_message
    message.id.should_not be_nil
  end

  it "has an applicant" do
    message = create_message
    message.applicant_id.should == applicant.id
  end
end
