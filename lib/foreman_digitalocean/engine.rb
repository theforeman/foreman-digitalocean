require 'fast_gettext'
require 'gettext_i18n_rails'
require 'fog'

module ForemanDigitalocean
  # Inherit from the Rails module of the parent app (Foreman), not the plugin.
  # Thus, inherits from ::Rails::Engine and not from Rails::Engine
  class Engine < ::Rails::Engine
    engine_name 'foreman_digitalocean'

    initializer 'foreman_digitalocean.register_gettext', :after => :load_config_initializers do
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman_digitalocean'

      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end

    initializer 'foreman_digitalocean.register_plugin', :after => :finisher_hook do
      Foreman::Plugin.register :foreman_digitalocean do
        requires_foreman '> 1.4'
        compute_resource ForemanDigitalocean::Digitalocean
      end
    end
  end

  require 'fog/digitalocean'
  require 'fog/digitalocean/models/compute/image'
  require 'fog/digitalocean/models/compute/server'
  require File.expand_path('../../../app/models/concerns/fog_extensions/digitalocean/server', __FILE__)
  require File.expand_path('../../../app/models/concerns/fog_extensions/digitalocean/image', __FILE__)
  Fog::Compute::DigitalOcean::Image.send(:include, FogExtensions::DigitalOcean::Image)
  Fog::Compute::DigitalOcean::Server.send(:include, FogExtensions::DigitalOcean::Server)
end
