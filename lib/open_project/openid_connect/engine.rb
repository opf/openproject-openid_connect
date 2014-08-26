require 'open_project/plugins'

module OpenProject::OpenIDConnect
  class Engine < ::Rails::Engine
    engine_name :openproject_openid_connect

    include OpenProject::Plugins::ActsAsOpEngine
    extend OpenProject::Plugins::AuthPlugin

    register 'openproject-openid_connect',
             :author_url => 'http://finn.de',
             :requires_openproject => '>= 3.1.0pre1',
             :settings => { 'default' => { 'providers' => {} } }

    assets %w(
      openid_connect/auth_provider-google.png
    )

    config.to_prepare do
      require_dependency 'open_project/openid_connect/hooks'
    end

    register_auth_providers do
      # Loading OpenID providers manually since rails doesn't do it automatically,
      # possibly due to non trivially module-name-convertible paths.
      require 'omniauth/openid_connect/provider'

      # load pre-defined providers
      Dir[File.expand_path('../../../omniauth/openid_connect/*.rb', __FILE__)].each do |file|
        require file
      end

      # Use OpenSSL default certificate store instead of HTTPClient's.
      # It's outdated and it's unclear how it's managed.
      OpenIDConnect.http_config do |config|
        config.ssl_config.set_default_paths
      end

      strategy :openid_connect do
        OmniAuth::OpenIDConnect::Provider.load_generic_providers
        OmniAuth::OpenIDConnect::Provider.available.map do |p|
          OpenProject::OmniAuth::Authorization.after_login provider: p.provider_name do |user, auth_hash, session|
            session[:oidc_state] = auth_hash.extra.raw_info.sub
            puts "fix this callback issue"
          end

          p.new.to_hash
        end
      end
    end
  end
end
