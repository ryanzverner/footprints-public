require 'spec_helper'
require 'spec_helpers/crafter_factory'

describe CraftersController do
  let(:repo) { Footprints::Repository }
  let(:test_date) { (Date.today + 2) }

  before :each do
    repo.crafter.destroy_all
  end

  it "sets return_to url in session when redirecting to log in" do
    get :profile
    expect(session[:return_to]).to eq profile_url
  end

  context "no authentication" do

    before :each do
      controller.stub(:authenticate)
      controller.stub(:employee?)
    end

    context "GET profile" do
      let(:crafter) { SpecHelpers::CrafterFactory.new.create }
      let(:current_user) { double(:crafter => crafter) }

      it "assigns current_user's crafter" do
        allow(controller).to receive(:current_user) { current_user }
        get :profile
        expect(assigns(:crafter)).to eq(crafter)
      end
    end

    context "PUT update" do
      let(:crafter) { SpecHelpers::CrafterFactory.new.create }
      let(:current_user) { double(:crafter => crafter) }
      let(:crafter_params) { { :seeking => true,
                                 :has_apprentice => true,
                                 :location => "London",
                                 :skill => "" } }

      before :each do
        allow(controller).to receive(:current_user) { current_user }
      end

      it "assigns current_user's crafter" do
        put :update, {:crafter => {:thing => "stuff"}}
        expect(assigns(:crafter)).to eq(crafter)
      end

      it "updates crafter record" do
        params = { :crafter => crafter_params.merge(:unavailable_until => test_date, :skill => "2") }
        put :update, params
        expect(crafter.seeking).to be_true
        expect(crafter.has_apprentice).to be_true
        expect(crafter.location).to eq("London")
        expect(crafter.unavailable_until).to eq(test_date)
        expect(crafter.skill).to eq(Skills.available_skills["Resident"])
        expect(response).to redirect_to(profile_path)
        expect(flash[:notice]).to eq("Successfully saved profile")
      end

      it 'does not lose entered data on validation errors' do
        params = { :crafter => crafter_params.merge(:unavailable_until => test_date) }
        put :update, params

        expect(assigns(:crafter).unavailable_until).to eq test_date
        expect(flash[:error]).to have_at_least(1).item
      end
    end

    context "GET seeking" do
      it "assigns crafters seeking residents" do
        allow_any_instance_of(CraftersPresenter).to receive(:seeking_resident_apprentice).and_return(["a", "b"])
        get :seeking

        expect(assigns(:crafters_seeking_residents)).to eq(["a", "b"])
      end

      it "assigns crafters seeking students" do
        allow_any_instance_of(CraftersPresenter).to receive(:seeking_student_apprentice).and_return(["a", "b"])
        get :seeking

        expect(assigns(:crafters_seeking_students)).to eq(["a", "b"])
      end
    end
  end
end
