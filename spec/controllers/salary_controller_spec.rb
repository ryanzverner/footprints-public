require 'spec_helper'

describe SalariesController do
  before :each do
    controller.stub(:authenticate)
    controller.stub(:employee?)
    admin_user = double('admin user', admin: true)
    allow(controller).to receive(:current_user).and_return(admin_user)
  end

  context '#edit' do
    it 'renders the salary edit form' do
      allow_any_instance_of(SalaryPresenter).to receive(:monthly_salaries_by_location).and_return({})
      allow_any_instance_of(SalaryPresenter).to receive(:annual_salaries_by_location).and_return({})
      allow_any_instance_of(SalaryPresenter).to receive(:currency_symbol).and_return("$")
      get :edit

      expect(response.status).to eq(200)
      expect(assigns(:salary_presenter)).to be_a(SalaryPresenter)
    end
  end

  context '#update' do
    it 'updates a monthly salary' do
      Footprints::Repository.monthly_apprentice_salary.create({:location => "Chicago", :duration => 3, :amount => 300.0})
      params = {"monthly" => {"Chicago" => {3 => 333.0, 4 => 444.0}}}
      post :update, params

      expect(Footprints::Repository.monthly_apprentice_salary.find_by_duration_at_location(3, "Chicago").amount).to eq(333.0)
    end
  end

  context '#create_monthly' do
    it "creates a new monthly salary record" do
      params = {"salary" => {"duration" => "14", "location" => "Chicago", "amount" => "500"}}
      post :create_monthly, params

      expect(Footprints::Repository.monthly_apprentice_salary.find_by_duration_at_location(14, "Chicago").amount).to eq(500.0)
    end
  end

  context '#destroy' do
    it 'destroys an existing salary record' do
      salary = Footprints::Repository.monthly_apprentice_salary.create({:location => "Chicago", :duration => 3, :amount => 300.0})

      expect{
        delete :destroy, id: salary.id}.to change(Footprints::Repository.monthly_apprentice_salary.model_class, :count).by(-1)
    end
  end
end
