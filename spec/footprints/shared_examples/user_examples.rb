shared_examples "user repository" do
  let(:repo) { described_class.new }
  let(:attrs) {{
    :login => "test@user.com",
    :email => "test@user.com" }}

  let(:user) { repo.create(attrs) }

  let(:auth_hash) {{
    'provider' => 'google_oauth2',
    'uid' => '123456',
    'info' => {
      'email' => 'test@user.com'
    }}}

  before do
    repo.destroy_all
    user
  end

  it "creates" do
    user.should_not be_nil
  end

  it "has an id" do
    user.id.should_not be_nil
  end

  it "finds by login" do
    repo.find_by_login(user.login).should == user
  end

  it "finds by id" do
    repo.find_by_id(user.id).should == user
  end

  it "finds by uid" do
    test_applicant = repo.find_or_create_by_auth_hash(auth_hash)
    repo.find_by_uid(test_applicant.uid).should == test_applicant
  end

  it "finds by email" do
    repo.find_by_email(attrs[:email]).should == user
  end

  it "creates by auth hash" do
    new_applicant = repo.find_or_create_by_auth_hash(auth_hash)
    new_applicant.should_not == user
  end

  it "finds by auth hash" do
    new_applicant = repo.find_or_create_by_auth_hash(auth_hash)
    test_applicant = repo.find_or_create_by_auth_hash(auth_hash)
    test_applicant.should == new_applicant
  end
end
