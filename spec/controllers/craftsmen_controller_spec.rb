require 'spec_helper'
require 'spec_helpers/craftsman_factory'

describe CraftsmenController do
  let(:repo) { Footprints::Repository }
  let(:test_date) { (Date.today + 2) }

  before :each do
    repo.craftsman.destroy_all
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
      let(:craftsman) { SpecHelpers::CraftsmanFactory.new.create }
      let(:current_user) { double(:craftsman => craftsman) }

      it "assigns current_user's craftsman" do
        allow(controller).to receive(:current_user) { current_user }
        get :profile
        expect(assigns(:craftsman)).to eq(craftsman)
      end
    end

    context "PUT update" do
      let(:craftsman) { SpecHelpers::CraftsmanFactory.new.create }
      let(:current_user) { double(:craftsman => craftsman) }
      let(:craftsman_params) { { :seeking => true,
                                 :has_apprentice => true,
                                 :location => "London",
                                 :skill => "" } }

      before :each do
        allow(controller).to receive(:current_user) { current_user }
      end

      it "assigns current_user's craftsman" do
        put :update, {:craftsman => {:thing => "stuff"}}
        expect(assigns(:craftsman)).to eq(craftsman)
      end

      it "updates craftsman record" do
        params = { :craftsman => craftsman_params.merge(:unavailable_until => test_date, :skill => "2") }
        put :update, params
        expect(craftsman.seeking).to be_true
        expect(craftsman.has_apprentice).to be_true
        expect(craftsman.location).to eq("London")
        expect(craftsman.unavailable_until).to eq(test_date)
        expect(craftsman.skill).to eq(Skills.available_skills["Resident"])
        expect(response).to redirect_to(profile_path)
        expect(flash[:notice]).to eq("Successfully saved profile")
      end

      it 'does not lose entered data on validation errors' do
        params = { :craftsman => craftsman_params.merge(:unavailable_until => test_date) }
        put :update, params

        expect(assigns(:craftsman).unavailable_until).to eq test_date
        expect(flash[:error]).to have_at_least(1).item
      end
    end

    context "GET seeking" do
      it "assigns craftsmen seeking residents" do
        allow_any_instance_of(CraftsmenPresenter).to receive(:seeking_resident_apprentice).and_return(["a", "b"])
        get :seeking

        expect(assigns(:craftsmen_seeking_residents)).to eq(["a", "b"])
      end

      it "assigns craftsmen seeking students" do
        allow_any_instance_of(CraftsmenPresenter).to receive(:seeking_student_apprentice).and_return(["a", "b"])
        get :seeking

        expect(assigns(:craftsmen_seeking_students)).to eq(["a", "b"])
      end
    end
  end
end
