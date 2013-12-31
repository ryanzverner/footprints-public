require 'spec_helper'

describe ApplicationController do
  controller do
    before_filter :authenticate

    def index
    end
  end

  before :each do
    allow(controller).to receive(:current_user).and_return(nil)
  end

  context "unauthorized browser requests" do
    it "responds with a status 'Found'" do
      get :index

      expect(response.status).to eq 302
    end

    it "redirects to log in page" do
      get :index

      expect(response).to redirect_to(oauth_signin_path)
    end
  end

  context "unauthorized ajax requests" do
    it "responds with status 'Unauthorized'" do
      request.headers["X-Requested-With"] = "XMLHttpRequest"
      get :index

      expect(response.status).to eq 401
    end
  end
end
