require 'spec_helper'
require 'reporting/reporting_interactor'

describe ReportingController do

  before :each do
    controller.stub(:authenticate)
    controller.stub(:employee?)
    admin_user = double('admin user', admin: true)
    allow(controller).to receive(:current_user).and_return(admin_user)
    allow_any_instance_of(Warehouse::JsonAPI).to receive(:find_all_employments).and_return([])
  end

  context '#index' do
    it 'should be succesfull' do
      get :index
      expect(response.status).to eq 200
    end

    it 'fetches data' do
      expect_any_instance_of(ReportingInteractor).to receive(:fetch_projection_data)
      get :index
    end

    it 'contains the data fetched' do
      get :index
      expect(assigns(:reporting_data)).not_to be_nil
    end
  end

  context 'authentication failure' do
    it 'displays an error message' do
      allow_any_instance_of(ReportingInteractor).to receive(:fetch_projection_data).and_raise(ReportingInteractor::AuthenticationError.new)

      get :index
      expect(flash[:error]).to eq ["You are not authorized through warehouse to use this feature"]
    end

    it 'redirects to the dashboard' do
      allow_any_instance_of(ReportingInteractor).to receive(:fetch_projection_data).and_raise(ReportingInteractor::AuthenticationError.new)

      get :index
      expect(response).to redirect_to(root_path)
    end

    it 'logs the error' do
      allow_any_instance_of(ReportingInteractor).to receive(:fetch_projection_data).and_raise(ReportingInteractor::AuthenticationError.new)
      expect(Rails.logger).to receive(:error).at_least(:once)

      get :index
    end
  end
end
