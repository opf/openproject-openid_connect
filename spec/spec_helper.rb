require 'spec_helper'

module OpenProject::OpenIDConnect::SpecHelpers
  def redirect_from_provider(name = 'heroku')
    # Emulate the provider's redirect with a nonsense code.
    get "/auth/#{name}/callback",
      :code => "foobar",
      :redirect_uri => "http://localhost:3000/auth/#{name}/callack"
  end

  def click_on_signin(pro_name = 'heroku')
    # Emulate click on sign-in for that particular provider
    get "/auth/#{pro_name}"
  end
end

RSpec.configure do |config|
  config.include OpenProject::OpenIDConnect::SpecHelpers

  config.before(:each) do
    allow(OpenProject::OmniAuth::Authorization).to receive(:callbacks).and_call_original
    allow(OpenProject::OmniAuth::Authorization).to receive(:after_login_callbacks).and_call_original
  end
end
