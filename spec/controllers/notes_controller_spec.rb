require 'spec_helper'

describe NotesController do
  let(:repo)      { Footprints::Repository }
  let(:applicant) { repo.applicant.create(:name => "First", :applied_on => Date.current,
                                          :discipline => "developer", :skill => "resident", :location => "Chicago") }
  let(:crafter) { double(:crafter, :id => 1) }

  before :each do
    repo.notes.destroy_all
  end

  context ":create" do
    it "creates note if user has crafter" do
      repo.crafter.create(:name => "A Crafter", :email => "acrafter@abcinc.com", :employment_id => "007")
      user = repo.user.create(:email => "acrafter@abcinc.com")
      controller.stub :current_user => user
      post :create, {"note" => {"body" => "Test Note", "applicant_id" => applicant.id}}
      expect(applicant.notes.last.body).to eq "Test Note"
    end

    it "redirects back to applicant if note cannot be created" do
      controller.stub :current_user => double("current_user", :id => 1, :crafter => nil)
      post :create, {"note" => {"body" => "Test Note", "applicant_id" => applicant.id}}
      expect(flash[:notice]).to eq("Only crafters can leave notes.")
      expect(response).to redirect_to(applicant_path(applicant))
    end
  end

  context ":edit" do
    it "gets the correct note" do
      note = repo.notes.create(:body => "Test Note", :applicant_id => applicant.id, :crafter_id => crafter.id)
      get :edit, {:id => note.id}
      expect(assigns[:note]).to eq(note)
    end
  end

  context ":update" do
    it "updates a note" do
      repo.crafter.create(:name => "A Crafter", :email => "acrafter@abcinc.com", :employment_id => "007")
      user = repo.user.create(:email => "acrafter@abcinc.com")
      controller.stub :current_user => user
      note = repo.notes.create(:body => "Test Note", :applicant_id => applicant.id, :crafter_id => crafter.id)
      patch :update, {"id" => note.id, "note" => {"id" => note.id, "body" => "Test Note Edit"}}
      expect(note.reload.body).to eq("Test Note Edit")
      expect(response).to redirect_to(applicant_path(applicant))
    end

    it "redirects back to applicant if note cannot be updated" do
      controller.stub :current_user => double("current_user", :id => 1, :crafter => nil)
      note = repo.notes.create(:body => "Test Note", :applicant_id => applicant.id)
      patch :update, {"id" => note.id, "note" => {"id" => note.id, "body" => "Test Note Edit"}}
      expect(note.reload.body).to eq("Test Note")
      expect(flash.notice).to eq("Only crafters can edit notes.")
      expect(response).to redirect_to(applicant_path(applicant))
    end
  end
end
