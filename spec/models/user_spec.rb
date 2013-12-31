require 'spec_helper'

describe User do
  let(:auth_hash) {{
    'provider' => 'google_oauth2',
    'uid' => '12345',
    'info' => {
    'email' => 'test@user.com'}
  }}

  before :each do
    User.destroy_all
  end

  it "returns an existing user if one already exists" do
    user = User.new
    User.should_receive(:find_by_uid).and_return user
    User.should_not_receive :save

    User.find_or_create_by_auth_hash(auth_hash).should == user
  end

  it "sets the attributes and saves if no existing email" do
    User.stub(:find_by_uid)
    User.find_or_create_by_auth_hash(auth_hash)
    user = User.last
    user.email.should == auth_hash['info']['email']
    user.provider.should == auth_hash['provider']
    user.uid.should == auth_hash['uid']
  end

  it "if user login doesn't match a craftsman email it doesn't assign user id" do
    User.stub(:find_by_uid)
    User.find_or_create_by_auth_hash(auth_hash)
    expect(User.last.craftsman_id).to be_nil
  end

  it "if user login matches craftsman email it assigns user id" do
    Craftsman.create(:email => auth_hash["info"]["email"], :employment_id => "test")
    User.stub(:find_by_uid)
    User.find_or_create_by_auth_hash(auth_hash)
    expect(User.last.craftsman_id).not_to be_nil
  end

  it "assigns craftsman on method call" do
    Craftsman.create(:email => auth_hash["info"]["email"], :employment_id => "test")
    User.stub(:find_by_uid)
    user = User.new(:email => auth_hash["info"]["email"])
    user.associate_craftsman
    expect(user.craftsman_id).not_to be_nil
  end
end
