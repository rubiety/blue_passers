Rails.application.config.middleware.use OmniAuth::Builder do  
  settings = YAML::load_file(Rails.root.join("config/twitter.yml"))
  settings = settings[Rails.env.to_s] if settings

  if settings
    provider :twitter, settings["key"], settings["secret"]
  end
end
