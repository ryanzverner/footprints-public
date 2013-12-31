require 'spec_helper'

describe SessionsController do
  let(:repo) { Footprints::Repository }

  it "flashes error and redirects to root if user cannot be logged in" do
    get :create
    expect(flash[:error].join("")).to include("it@abcinc.com")
    expect(response).to redirect_to(oauth_signin_path)
  end

  it "logs an error message when user cannot be logged in" do
    expect(Rails.logger).to receive(:error).at_least(:once)
    get :create
  end

  describe "signing in/out with Oauth" do
    before :each do
      repo.user.destroy_all

      auth_hash = OmniAuth::AuthHash.new({ provider: "google_oauth2",
                                           uid: "123",
                                           info: { email: "test@test.com" },
                                           extra: { id_token: "ID Token" }})

      request.env["omniauth.auth"] = auth_hash
    end

    it "creates a new user from Oauth creds if none exist" do
      get :create

      user = User.first
      expect(user.uid).to      eq('123')
      expect(user.email).to    eq("test@test.com")
      expect(user.provider).to eq('google_oauth2')
    end

    it "finds existing user by their Oauth credentials" do
      user = repo.user.create(email: "test@test.com", uid: "123")
      get :create
      expect(session[:user_id]).to eq(user.id)
    end

    it "stores the users id_token in the session" do
      get :create
      expect(session[:id_token]).to eq("ID Token")
    end

    it "destroys session when signing out" do
      session[:user_id] = 1
      session[:id_token] = "ID Token"
      get :destroy
      expect(session[:user_id]).to be_nil
      expect(session[:id_token]).to be_nil
    end

    context "authentication errors" do
      before :each do
        allow(Rails.application.config).to receive(:prefetch_craftsmen) { true }
        expect(Warehouse::PrefetchCraftsmen).to receive(:new).and_return(WarehousePrefetchCraftsmenWithAuthenticationError.new)

        request.env["omniauth.auth"] = {:extra => {:id_token => "invalid token"},
          :info => {:email => "some email"},
          :uid => "007"}
      end

      it "catches warehouse authentication errors" do
        get :create

        expect(flash[:error].join("")).to include "not authorized"
        expect(response).to redirect_to(oauth_signin_path)
      end

      class WarehousePrefetchCraftsmenWithAuthenticationError
        def execute(token)
          raise Warehouse::AuthenticationError.new([])
        end
      end

      it "logs an error message on warehouse authentication errors" do
        expect(Rails.logger).to receive(:error).at_least(:once)

        get :create
      end
    end

    context "authorization errors" do
      before :each do
        allow(Rails.application.config).to receive(:prefetch_craftsmen) { true }
        expect(Warehouse::PrefetchCraftsmen).to receive(:new).and_return(WarehousePrefetchCraftsmenWithAuthorizationError.new)

        request.env["omniauth.auth"] = {:extra => {:id_token => "invalid token"},
                                        :info => {:email => "some email"},
                                        :uid => "007"}
      end

      it 'catches warehouse authorization errors' do
        get :create

        expect(flash[:error].join("")).to include 'not authorized'
        expect(response).to redirect_to(oauth_signin_path)
      end

      class WarehousePrefetchCraftsmenWithAuthorizationError
        def execute(token)
          raise Warehouse::AuthorizationError.new([])
        end
      end
    end

    it "redirects to return_to after sign in" do
      session[:return_to] = profile_url
      get :create
      expect(response).to redirect_to(profile_url)
    end

    it "redirects to the root page if no return_to is found" do
      session[:return_to] = nil
      get :create
      expect(response).to redirect_to(root_url)
    end
  end
end
