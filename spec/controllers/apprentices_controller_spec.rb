require "spec_helper"

describe ApprenticesController do
  before :each do
    controller.stub(:authenticate)
    controller.stub(:employee?)
    admin_user = double('admin user', admin: true)
    allow(controller).to receive(:current_user).and_return(admin_user)
  end

  context "GET #index" do
    it 'displays an error message' do
      allow_any_instance_of(ApprenticesInteractor).to receive(:fetch_all_residents).and_raise(ApprenticesInteractor::AuthenticationError.new)

      get :index
      expect(flash[:error]).to eq ["You are not authorized through warehouse to use this feature"]
    end

    it "renders the index view" do
      get :index

      expect(response.status).to eq(200)
      expect(response).to render_template :index
    end

    it "fetches all resident apprentices" do
      allow_any_instance_of(ApprenticesInteractor).to receive(:fetch_all_residents).and_return(:raw_residents)
      allow_any_instance_of(ApprenticeListPresenter).to receive(:residents).and_return(:presented_residents)

      get :index

      expect(assigns(:residents)).to eq(:presented_residents)
    end

    it "fetches all student apprentices" do
      allow_any_instance_of(ApprenticesInteractor).to receive(:fetch_all_students).and_return(:raw_students)
      allow_any_instance_of(StudentListPresenter).to receive(:students).and_return(:presented_students)

      get :index

      expect(assigns(:students)).to eq(:presented_students)
    end
  end

  context "GET #edit" do
    it "renders the edit view" do
      get :edit, :id => 208

      expect(response.status).to eq(200)
      expect(response).to render_template :edit
    end

    it "sets the current apprentice being edited" do
      get :edit, :id => 208

      allow_any_instance_of(ApprenticesInteractor).to receive(:fetch_resident_by_id)

      expect(assigns[:resident]).to be_a(ApprenticeListPresenter::PresentedApprentice)
    end
  end

  context "PUT #update" do
    it "responds 302 after updating a resident" do
      put :update, :id => "208", :apprentice => {:end_date => Date.tomorrow}
      expect(response.status).to eq(302)
    end

    it "throws an error when no value is provided" do
      put :update, :id => "208", :apprentice => {:end_date => ""}
      expect(flash[:error]).to eq ["Please provide a valid date"]
    end

    it "redirects to the resident show page" do
      put :update, :id => "208", :apprentice => {:end_date => Date.tomorrow}
      expect(response).to redirect_to("/apprentices/")
    end
  end
end
