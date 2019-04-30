require "spec_helper"
require "./lib/crafters/crafters_presenter"
require './lib/crafters/skills'

describe CraftersPresenter do
  before :each do
    @repo = Footprints::Repository.crafter
    @seeking_resident_apprentice = @repo.create(name: "Test", employment_id: "1", email: "test@abcinc.com", seeking: true, skill: Skills.get_key_for_skill("Resident"))
    @seeking_student_apprentice  = @repo.create(name: "Test", employment_id: "2", email: "test@abcinc.com", seeking: true, skill: Skills.get_key_for_skill("Student"))
  end

  after :each do
    Footprints::Repository.crafter.destroy_all
  end

  it "returns all crafters seeking a resident apprentice" do
    presenter = CraftersPresenter.new(@repo)
    presenter.seeking_resident_apprentice.first.should == @seeking_resident_apprentice
  end

  it "returns all crafters seeking a student apprentice" do
    presenter = CraftersPresenter.new(@repo)
    presenter.seeking_student_apprentice.first.should == @seeking_student_apprentice
  end
end
