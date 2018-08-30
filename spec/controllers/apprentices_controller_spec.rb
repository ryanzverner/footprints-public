require "spec_helper"

describe ApprenticesController do
  before :each do
    controller.stub(:authenticate)
    controller.stub(:employee?)
    admin_user = double('admin user', admin: true)
    allow(controller).to receive(:current_user).and_return(admin_user)
  end

  context "GET #index" do

    it "renders the index view" do
      get :index

      expect(response.status).to eq(200)
      expect(response).to render_template :index
    end

    it "fetches all apprentices" do
      allow(Footprints::Repository.apprentice).to receive(:all).and_return(:fake_return)

      get :index
      
      expect(assigns(:apprentices)).to eq(:fake_return)
    end
  end

  context "GET #edit" do
    it "renders the edit view" do
      allow(Footprints::Repository.apprentice).to receive(:find)

      get :edit, :id => 1

      expect(response.status).to eq(200)
      expect(response).to render_template :edit
    end

    it "sets the current apprentice being edited" do
      allow(Footprints::Repository.apprentice).to receive(:find).and_return(Apprentice.new)

      get :edit, :id => 208

      expect(assigns[:apprentice]).to be_a(Apprentice)
    end
  end

  context "PUT #update" do
  
    it "responds 302 after updating a resident" do
      allow(Footprints::Repository.apprentice).to receive(:find).and_return(Apprentice.new)
      allow_any_instance_of(Apprentice).to receive(:save!)
      put :update, :id => "208", :apprentice => {:end_date => Date.tomorrow}
      expect(response.status).to eq(302)
    end

    it "throws an error when no value is provided" do
      allow(Footprints::Repository.apprentice).to receive(:find).and_return(Apprentice.new)
      put :update, :id => "208", :apprentice => {:end_date => ""}
      expect(flash[:error]).to eq ["Please provide a valid date"]
    end

    it "redirects to the apprentice index page" do
      allow(Footprints::Repository.apprentice).to receive(:find).and_return(Apprentice.new)
      allow_any_instance_of(Apprentice).to receive(:save!)
      put :update, :id => "208", :apprentice => {:end_date => Date.tomorrow}
      expect(response).to redirect_to("/apprentices/")
    end
  end
end
