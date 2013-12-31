shared_examples "applicant repository" do
  let(:yesterday) { Date.yesterday }
  let(:today) { Date.today }
  let(:repo) { described_class.new }
  let(:default_attrs) {{
    :name => "test applicant",
    :applied_on => today,
    :discipline => "developer",
    :skill => "resident",
    :location => "Chicago"
  }}

  def create_applicant(attrs = {})
    repo.create(default_attrs.merge(attrs))
  end

  before do
    repo.destroy_all
  end

  it "creates" do
    applicant = create_applicant
    applicant.should_not be_nil
  end

  it "has an id" do
    applicant = create_applicant
    applicant.id.should_not be_nil
  end

  it "finds by name" do
    applicant = create_applicant
    repo.find_by_name(default_attrs[:name]).should == applicant
  end

  it "finds by email" do
    applicant = create_applicant(:email => 'test@example.com')
    repo.find_by_email('test@example.com').should == applicant
  end

  it "finds by id" do
    applicant = create_applicant
    repo.find_by_id(applicant.id).should == applicant
  end

  it "finds by query" do
    applicant = create_applicant
    repo.where("name like ?", "#{default_attrs[:name]}").first.should == applicant
  end

  it 'finds like' do
    applicant = create_applicant
    expect(repo.find_like('test').first).to eq applicant
  end

  it "validates unique email" do
    repo.create(
      :name => "some name",
      :applied_on => today,
      :email => "test1@example.com",
      :discipline => "developer",
      :skill => "resident",
      :location => "Chicago"
    )
    expect { repo.create(
        :email => "test1@example.com",
        :name => "some name",
        :applied_on => today,
        :discipline => "developer",
        :skill => "resident",
        :location => "Chicago"
      )
    }.to raise_exception(Footprints::RecordNotValid)
  end

  it "raises RecordNotFound error" do
    expect { repo.find(109) }.to raise_exception(Footprints::RecordNotFound)
  end

  it "raises RecordNotFound error" do
    repo.destroy_all
    lambda {
      repo.find(1)
    }.should raise_exception(Footprints::RecordNotFound)
  end

  context 'get unassigned, unarchived applicants' do
    it 'includes unarchived applicants without a craftsman' do
      unassigned_applicant = create_applicant(archived: false)
      archived_applicant = create_applicant(archived: true)

      expect(repo.get_unassigned_unarchived_applicants).to eq [unassigned_applicant]
    end

    it 'excludes applicants who already have a craftsman' do
      Footprints::Repository.craftsman.create(name: "Jimi Hendrix", employment_id: 1)
      assigned_applicant = create_applicant(:assigned_craftsman => "Jimi Hendrix")
      expect(repo.get_unassigned_unarchived_applicants).to eq []
    end
  end


  context "filter applicants" do
    let!(:applied_on_applicant) { create_applicant } 
    let!(:initial_reply_on_applicant) { create_applicant(initial_reply_on: Date.today) } 
    let!(:sent_challenge_on_applicant) { create_applicant(sent_challenge_on: Date.today) }
    let!(:completed_challenge_on_applicant) { create_applicant(completed_challenge_on: Date.today) } 
    let!(:reviewed_on_applicant) { create_applicant(reviewed_on: Date.today) } 
    let!(:offered_on_applicant) { create_applicant(offered_on: Date.today) } 
    let!(:decision_made_on_applicant) { create_applicant(decision_made_on: Date.today) } 

    it "finds applied_on applicants" do
      expect(repo.get_applicants_by_state('applied_on')).to eq [applied_on_applicant]
    end

    it "finds initial_reply_on applicants" do
      expect(repo.get_applicants_by_state('initial_reply_on')).to eq [initial_reply_on_applicant]
    end

    it "finds challenge_sent_on applicants" do
      expect(repo.get_applicants_by_state('sent_challenge_on')).to eq [sent_challenge_on_applicant]
    end

    it "finds completed_challenge_on applicants" do
      expect(repo.get_applicants_by_state('completed_challenge_on')).to eq [completed_challenge_on_applicant]
    end

    it "finds reviewed_on applicants" do
      expect(repo.get_applicants_by_state('reviewed_on')).to eq [reviewed_on_applicant]
    end

    it "finds decision_made_on applicants" do
      expect(repo.get_applicants_by_state('decision_made_on')).to eq [decision_made_on_applicant]
    end
  end

  it 'gets all archived' do
     archived = create_applicant(:archived => true) 
     unarchived = create_applicant
     expect(repo.get_all_archived_applicants).to eq [archived]
  end

  it 'gets all unarchived' do
     archived = create_applicant(:archived => true) 
     unarchived = create_applicant
     expect(repo.get_all_unarchived_applicants).to eq [unarchived]
  end
end
