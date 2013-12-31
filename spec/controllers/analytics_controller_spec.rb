require 'spec_helper'

describe AnalyticsController do

  before :each do
    controller.stub(:authenticate)
    controller.stub(:employee?)
  end

  describe "GET index" do
    it "successfully displays the page" do
      get :index
      expect(response.status).to eq(200)
    end

    it "assigns a default falloff value" do
      get :index
      expect(assigns(:falloff)).to eq(60)
    end

    it "assigns the user-submitted falloff value" do
      params = { :falloff => "30"}
      get :index, params
      expect(assigns(:falloff)).to eq(30)
    end
  end
end
