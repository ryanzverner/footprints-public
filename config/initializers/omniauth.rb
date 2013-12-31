Rails.application.config.middleware.use OmniAuth::Builder do
  OmniAuth.config.logger = Rails.logger

  if Rails.env.development? || Rails.env.test?
    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: "google_oauth2",
      uid: "107478018817920458918",
      info: {
        name: "Megan Smith",
        email: "you@abcinc.com",
        first_name: "Megan",
        last_name: "Smith"
      },
      extra: {
        id_token: "ID_TOKEN"
      }
                                                                       })

    provider :google_oauth2
  else
    begin
      config      = Rails.root.join('config/omniauth.yml')
      credentials = YAML.load_file(config)
      provider :google_oauth2, credentials[Rails.env]["client_id"], credentials[Rails.env]["client_secret"]
    rescue Exception => e
      puts "OmniAuth configuration failed."
      puts e
      puts e.backtrace
    end
  end
end
