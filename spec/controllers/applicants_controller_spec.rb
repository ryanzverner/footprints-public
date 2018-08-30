require 'spec_helper'

describe ApplicantsController do
  let(:applicant)            { Footprints::Repository.applicant.new }
  let(:repo)                 { Footprints::Repository }
  let(:applied_date)         { Date.today - 7.days }
  let(:initial_reply_date)   { Date.today - 6.days }
  let(:completed_ttt_date)   { Date.today - 5.days }
  let(:reviewed_date)        { Date.today - 4.days }
  let(:resubmitted_ttt_date) { Date.today - 3.days }
  let(:decision_made_date)   { Date.today - 2.days }
  let(:first_applicant)  { repo.applicant.create(:name => "First", :applied_on => applied_date,
                                                :discipline => "developer", :skill => "resident", :location => "Chicago") }
  let(:second_applicant) { repo.applicant.create(:name => "Second", :applied_on => applied_date, :initial_reply_on => initial_reply_date,
                                                 :discipline => "developer", :skill => "resident", :location => "Chicago") }

  let(:third_applicant) { repo.applicant.create(:name => "Third", :applied_on => applied_date, :initial_reply_on => initial_reply_date,
                                                :completed_challenge_on => completed_ttt_date, :discipline => "developer", :skill => "resident",
                                                :location => "Chicago") }

  let(:fourth_applicant) { repo.applicant.create(:name => "Fourth", :applied_on => applied_date, :initial_reply_on => initial_reply_date,
                                                 :completed_challenge_on => completed_ttt_date, :reviewed_on => reviewed_date,
                                                 :discipline => "developer", :skill => "resident", :location => "Chicago") }

  let(:fifth_applicant) { repo.applicant.create(:start_date => Date.today, :end_date => Date.tomorrow,
                                                :name => "Fifth",  :applied_on => applied_date, :initial_reply_on => initial_reply_date,
                                                :completed_challenge_on => completed_ttt_date, :reviewed_on => reviewed_date,
                                                :resubmitted_challenge_on => resubmitted_ttt_date, :discipline => "developer", :skill => "resident",
                                                :location => "Chicago") }

  let(:sixth_applicant) { repo.applicant.create(:name => "Sixth", :applied_on => applied_date, :initial_reply_on => initial_reply_date,
                                                :completed_challenge_on => completed_ttt_date, :reviewed_on => reviewed_date,
                                                :resubmitted_challenge_on => resubmitted_ttt_date, :decision_made_on => decision_made_date,
                                                :discipline => "developer", :skill => "resident", :location => "Chicago") }

  let(:seventh_applicant) { repo.applicant.create(:name => "Seventh", :applied_on => applied_date,
                                                  :initial_reply_on => initial_reply_date,
                                                  :completed_challenge_on => completed_ttt_date, :reviewed_on => reviewed_date,
                                                  :resubmitted_challenge_on => resubmitted_ttt_date, :decision_made_on => decision_made_date,
                                                  :assigned_craftsman => "A. Craftsman", :discipline => "developer", :skill => "resident", :location => "Chicago") }

  let(:london_applicant) { repo.applicant.create(:name => "London", :applied_on => applied_date,
                                                 :discipline => "developer", :skill => "resident", :location => "London") }


  def login_as_admin
    admin_user = double('user', admin: true)
    allow(controller).to receive(:current_user).and_return(admin_user)
  end

  def login_as_non_admin
    non_admin_user = double('user', admin: false)
    allow(controller).to receive(:current_user).and_return(non_admin_user)
  end

  before :each do
    repo.applicant.destroy_all
    repo.craftsman.destroy_all
    controller.stub(:authenticate)
    controller.stub(:employee?)
  end

  context ":index" do
    it "assigns applicants" do
      applicants = [first_applicant, second_applicant]
      allow(applicants).to receive(:paginate) { applicants }
      allow(repo.applicant).to receive(:get_applicants) { applicants }
      get :index, { "status" => "test filter" }
      expect(assigns(:applicants)).to eq([first_applicant, second_applicant])
    end
  end

  context ":new" do
    it "assigns applicant to new instance of Applicant" do
      login_as_admin
      get :new
      expect(assigns(:applicant)).to be_a_new(Applicant)
    end

    it "only allows admins to access the new applicant page" do
      login_as_non_admin
      get :new
      expect(response).to redirect_to(root_path)
    end
  end

  context ":create" do
    it "allows admins to create a new record" do
      login_as_admin
      attrs = { "applicant" => {  :name => "Bar", :applied_on => "01/01/2014", :about => "about", :software_interest => "software_interest", :reason => "reason", :discipline => "developer", :skill => "resident", :location => "Chicago"}}
      post :create, attrs
      app = repo.applicant.find_by_name("Bar")
      expect(app.applied_on.to_s).to eq("2014-01-01")
    end

    it "redirects to applicant profile after creation" do
      login_as_admin
      attrs = { "applicant" => {  :name => "Bar", :applied_on => "01/01/2014", :discipline => "developer", :skill => "resident", :location => "Chicago" }}
      post :create, attrs
      expect(response).to redirect_to(applicant_path(assigns(:applicant)))
    end

    it "doesnt create a new record with invalid params" do
      login_as_admin
      attrs = { "applicant" => {:name => "Bar", :applied_on => "" ,  :initial_reply_on => "", :completed_challenge_on => "" , :reviewed_on => "", :resubmitted_challenge_on => "", :decision_made_on => "", :start_date => "", :end_date => "", :discipline => "developer", :skill => "resident", :location => "Chicago"}}
      post :create, attrs
      expect(response).to render_template :new
    end

    it "doesn't allow a non-admin to create a new applicant" do
      login_as_non_admin
      attrs = { "applicant" => {  :name => "Bar", :applied_on => "01/01/2014", :discipline => "developer", :skill => "resident", :location => "Chicago" }}
      expect{ post :create, attrs }.to_not change(repo.applicant.model_class, :count)
    end
  end

  context ":show" do
    it "has applicant profile" do
      test_app = repo.applicant.create(:name => "Test", :applied_on => Date.today, :discipline => "developer", :skill => "resident", :location => "Chicago")
      params = { :id => test_app.id }
      get :show, params
      expect(assigns[:applicant]).to eq(test_app)
    end
  end

  context ":edit" do
    it "shows edit page for an applicant" do
      edit_app = repo.applicant.create(:name => "Test", :applied_on => Date.today,
                                       :discipline => "developer", :skill => "resident", :location => "Chicago")
      params = { :id => edit_app.id }
      get :edit, params
      expect(assigns[:applicant]).to eq(edit_app)
    end
  end

  context ":update" do
    it "can update an applicant" do
      allow(controller).to receive(:render)
      post :update, {:id => first_applicant.id,  "applicant" => {:name => "Meagan", "applied_on"=>"02/10/2014", "initial_reply_on"=>"", "completed_challenge_on"=>"", "reviewed_on"=>"", "resubmitted_challenge_on"=>"", "decision_made_on"=>"","start_date"=>"","end_date"=>""}}
      expect(assigns[:applicant].name).to eq "Meagan"
    end

    it "updates craftsman_id from assigned_craftsman" do
      repo.craftsman.create({:name => "A. Craftsman", :employment_id => "1234", :email => "test@abcinc.com"})
      craftsman = repo.craftsman.find_by_name("A. Craftsman")
      post :update, { :id => first_applicant.id, "applicant" =>  {:name => "Meagan", "applied_on"=>"02/10/2014", "initial_reply_on"=>"", "completed_challenge_on"=>"", "reviewed_on"=>"", "resubmitted_challenge_on"=>"", "decision_made_on"=>"","start_date"=>"","end_date"=>"", "assigned_craftsman" => "A. Craftsman"}}
      expect(assigns[:applicant].craftsman_id).to eq craftsman.id
    end

    it "returns nil for craftsman_id if assigned_craftsman doesn't exist" do
      test_app = first_applicant
      post :update, { :id => test_app.id, "applicant" =>  {:name => "Meagan", "applied_on"=>"02/10/2014", "initial_reply_on"=>"", "completed_challenge_on"=>"", "reviewed_on"=>"", "resubmitted_challenge_on"=>"", "decision_made_on"=>"","start_date"=>"","end_date"=>"", "assigned_craftsman" => "B. Craftsman"}}
      expect(assigns[:applicant].craftsman_id).to eq nil
    end

    it 'updates applicant fields' do
      applicant = repo.applicant.create(:name => "Joe", :applied_on => applied_date)
      params = {"name" => "Joe Doe", "assigned_craftsman" => "A Craftsman", "location" => "London", "discipline" => "Developer", "about" => "Just love software." }
      post :update, { :id => applicant.id, "applicant" => params }

      params.each do |field, value|
        expect(assigns[:applicant].send(field.to_sym)).to eq value
      end
    end

    it "redirects to profile after updating" do
      allow(controller).to receive(:render)
      post :update, {:id => first_applicant.id,  "applicant" => {:name => "Meagan", "applied_on"=>"02/10/2014", "initial_reply_on"=>"", "completed_challenge_on"=>"", "reviewed_on"=>"", "resubmitted_challenge_on"=>"", "decision_made_on"=>"","start_date"=>"","end_date"=>""}}
      expect(assigns(:applicant)).to eq(first_applicant)
      expect(response).to redirect_to(applicant_path(first_applicant))
    end

    # later state dates can't come before previous state dates
    it "redirects to edit path if invalid attrs" do
      test_app = first_applicant
      post :update, {:id => test_app.id,  "applicant" => {:name => "Meagan", "applied_on"=>"02/10/2014", "initial_reply_on"=>"02/09/2014", "completed_challenge_on"=>"", "reviewed_on"=>"", "resubmitted_challenge_on"=>"", "decision_made_on"=>"","start_date"=>"","end_date"=>""}}
      expect(response).to render_template :edit
    end

    it "doesn't allow to update the application date" do
      original_application_date = first_applicant.applied_on
      post :update, {:id => first_applicant.id,  "applicant" => { "applied_on" => "01/01/1984" }}
      expect(assigns[:applicant].applied_on).to eq original_application_date
    end
  end

  context ":destroy" do
    it "can delete an applicant as an admin" do
      login_as_admin
      test_app = first_applicant

      expect{
        delete :destroy, id: test_app.id}.to change(repo.applicant.model_class, :count).by(-1)

    end

    it "redirects after deleting" do
      login_as_admin
      test_app = first_applicant
      delete :destroy, id: test_app.id
      expect(response).to redirect_to(applicants_path)
    end

    it "does not allow a non-admin user to delete" do
      login_as_non_admin
      test_app = first_applicant
      expect{ delete :destroy, id: test_app.id }.to_not change(repo.applicant.model_class, :count)
    end
  end

  context ":submit" do
    let(:params) { {:type        => "developer",
                    :name        => "Tes Teroo",
                    :email       => "tes@teroo.com",
                    :publication => "http://my.blog.com",
                    :story       => "Once upon a time...",
                    :passion     => "Making stuff is cool.",
                    :position    => "student",
                    :desire      => "I'm hungry for knowledge"} }

    it "returns 200 OK if valid params" do
      allow(EighthlightApplicantsInteractor).to receive(:apply) { [200, "Body"] }
      post :submit, params
      expect(response.status).to eq(200)
      expect(response.body).to eq("Body")
    end
  end

  context "modified date params" do
    let(:params) {
      {:applicant => {
        :name => "A Applicant",
        :email => "a.applicant@example.com",
        :applied_on => "234872458734958739458"}}
    }

    it "redirects back to form and displays error message if date cannot be parsed" do
      login_as_admin
      controller.env["HTTP_REFERER"] = "http://localhost:3000/applicants/new"
      post :create, params
      expect(flash[:error]).to eq ["Validation failed: Applied on can't be blank"]
      expect(response).to render_template :new
    end
  end

  context "hiring decision" do
    let!(:craftsman) { repo.craftsman.create(:name => "A. Craftsman", :email => "acraftsman@abcinc.com", :employment_id => 007) }

    context "#make_decision" do
      let(:employment_post_dummy) { double(Warehouse::EmploymentPost, :add_resident! => nil) }

      before :each do
        expect(Warehouse::EmploymentPost).to receive(:new).and_return(employment_post_dummy)
        login_as_admin
        fifth_applicant.update_attributes(:assigned_craftsman => "A. Craftsman",
                                          :start_date => Date.today + 5.days,
                                          :end_date => Date.today + 6.months)
      end

      it "only allows hired and decision_made_on to be modified" do
        params = {:id => fifth_applicant.id, :applicant => {mentor: "A. Craftsman", name: "Superman"} }

        post :make_decision, params
        fifth_applicant.reload
        expect(fifth_applicant.name).to eq("Fifth")
      end

      it "displays an error message when there is no mentor" do
        params = {:id => fifth_applicant.id, :applicant => {mentor: nil} }

        post :make_decision, params
        expect(flash[:error].join("")).to include("Mentor must be selected")
        expect(response).to redirect_to(applicant_path(params[:id]))
      end

      it "displays an error message when the mentor is invalid" do
        params = {:id => fifth_applicant.id, :applicant => {mentor: "Not available"} }
        post :make_decision, params
        expect(flash[:error].join("")).to include("is not a valid craftsman")
        expect(response).to redirect_to(applicant_path(params[:id]))
      end

      it "updates hired applicant with a mentor" do
        params = {:id => fifth_applicant.id, :applicant => {:mentor => "A. Craftsman"}}
        post :make_decision, params
        fifth_applicant.reload
        expect(fifth_applicant.mentor).to eq("A. Craftsman")
      end

      it "shows a success message when applicant is hired" do
        params = {:id => fifth_applicant.id, :applicant => {:mentor => "A. Craftsman"}}
        post :make_decision, params
        fifth_applicant.reload

        expect(flash[:notice]).to include("Applicant hired")
        expect(response).to redirect_to(applicant_path(params[:id]))
      end
    end

    context "#hire" do
      it "displays hire form" do
        login_as_admin
        get :hire, {:id => fifth_applicant.id}
        expect(assigns(:applicant)).to eq(fifth_applicant)
        expect(response.code).to eq("200")
      end
    end

    context "deny_applicant" do
      it "archives and sets hired to no when denying an applicant" do
        get :deny_application, {:id => first_applicant.id}
        expect(assigns(:applicant)).to eq(first_applicant)
        expect(first_applicant.reload.hired).to eq("no")
        expect(first_applicant.archived).to be_true
      end

      it 'redirects to new applicants if denyed applicant without craftsman' do
        get :deny_application, {:id => first_applicant.id}
        expect(response).to redirect_to unassigned_applicants_path
      end

      it 'redirects to root if denyed applicant with craftsman' do
        first_applicant.update_attribute(:assigned_craftsman, "A. Craftsman")
        get :deny_application, {:id => first_applicant.id}
        expect(response).to redirect_to root_path
      end
    end
  end

  context "generating offer letter" do
    before :each do
      repo.monthly_apprentice_salary.create({:location => first_applicant.location, :duration => 4, :amount => 400.0})
      repo.monthly_apprentice_salary.create({:location => first_applicant.location, :duration => 5, :amount => 500.0})
      repo.monthly_apprentice_salary.create({:location => london_applicant.location, :duration => 9, :amount => 500.0})
      repo.monthly_apprentice_salary.create({:location => london_applicant.location, :duration => 10, :amount => 500.0})
      login_as_admin
    end
    after :each do
      repo.monthly_apprentice_salary.destroy_all
    end

    it "renders a modal with the apprenticeship duration options for Chicago" do
      get :offer_letter_form, id: first_applicant.id
      expect(assigns(:duration_options)).to eq([4,5])
      expect(response).to render_template("applicants/chicago_offer_letter_form")
    end

    it "renders a modal with the apprenticeship offer letter options for London" do
      get :offer_letter_form, id: london_applicant.id
      expect(assigns(:duration_options)).to eq([9,10])
      expect(response).to render_template("applicants/london_offer_letter_form")
    end

    it "renders a modal with the apprenticeship offer letter options for Los Angeles" do
      los_angeles_applicant = repo.applicant.create(:name => "New Applicant",
                                                    :applied_on => applied_date,
                                                    :discipline => "developer",
                                                    :skill => "resident",
                                                    :location => "Los Angeles")
      get :offer_letter_form, id: los_angeles_applicant.id

      expect(response).to render_template("applicants/los_angeles_offer_letter_form")
    end

    it "renders a modal with a notice when the applicant is missing a location" do
      homeless_applicant = repo.applicant.create(:name => "Homeless",
                                                :applied_on => applied_date,
                                                :discipline => "developer",
                                                :skill => "resident",
                                                :location => "")
      get :offer_letter_form, id: homeless_applicant.id

      expect(response).to render_template("applicants/unknown_location_offer_letter_form")
    end

    it "sets start_date, end_date (as a Sunday), and offered_on on an applicant" do
      post :update_employment_dates, {:id => fifth_applicant.id, :applicant => {:start_date => Date.today + 1.day, :duration => "6", :offered_on => Date.today}}
      applicant = fifth_applicant.reload
      expect(applicant.start_date).to eq(Date.today + 1.day)
      expect(applicant.end_date.cwday).to eq(7)
      expect(applicant.offered_on).to eq(Date.today)
    end

    it "only allows start_date, end_date, and offered_on to be modified" do
      post :update_employment_dates, {:id => fifth_applicant.id, :applicant => {:start_date => Date.today + 1.day, :end_date => Date.today + 6.months, :offered_on => Date.today, :name => "Batman"}}
      applicant = fifth_applicant.reload
      expect(applicant.name).to eq("Fifth")
    end

    it "sends a notification email to admin and CFO" do
      allow_any_instance_of(ApplicantOfferLetterGenerator).to receive(:build_offer_letter_as_json) { "some json" }
      allow(NotificationMailer).to receive(:offer_letter_generated).and_call_original
      allow(OfferLetterPost).to receive(:get_pdf) { "pdf" }
      get :offer_letter, {:id => fifth_applicant.id, :format => :pdf}
      expect(NotificationMailer).to have_received(:offer_letter_generated).with(fifth_applicant)
    end

    it "returns a PDF from Argon" do
      allow_any_instance_of(ApplicantOfferLetterGenerator).to receive(:build_offer_letter_as_json) { "some json" }
      allow(OfferLetterPost).to receive(:get_pdf) { "pdf" }
      get :offer_letter, {:id => fifth_applicant.id, :format => :pdf}
      expect(response.content_type).to eq("application/pdf")
      expect(response.status).to eq(200)
    end

    it "returns an onboarding documents pdf from argon" do
      allow(OfferLetterPost).to receive(:get_pdf) { "pdf" }
      get :onboarding_letters, {:id => fifth_applicant.id, :format => :pdf}
      expect(response.content_type).to eq("application/pdf")
      expect(response.status).to eq(200)
      expect(response.body).to eq("pdf")
    end
  end

  context 'unassigned' do
    it 'cannot be viewed if not admin' do
      login_as_non_admin
      get :unassigned
      expect(response).to redirect_to(root_path)
    end
  end

  context 'assign_craftsman' do
    it 'cannot be viewed if not admin' do
      login_as_non_admin
      get :assign_craftsman, {id: '1'}
      expect(response).to redirect_to(root_path)
    end

    context 'logged in as admin' do
      before { login_as_admin }

      it 'calls dispatcher with correct applicant' do
        expect_any_instance_of(ApplicantDispatch::Dispatcher).to receive(:assign_applicant)
        get :assign_craftsman, {id: first_applicant.id}

        expect(response).to redirect_to(unassigned_applicants_path)
      end
    end
  end
end
