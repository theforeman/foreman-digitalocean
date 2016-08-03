require 'fast_gettext'
require 'gettext_i18n_rails'

module ForemanDigitalocean
  class Engine < ::Rails::Engine
    engine_name 'foreman_digitalocean'

    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]

    initializer 'foreman_digitalocean.register_gettext', :after => :load_config_initializers do
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman_digitalocean'

      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end

    initializer 'foreman_digitalocean.register_plugin', :before => :finisher_hook do
      Foreman::Plugin.register :foreman_digitalocean do
        requires_foreman '>= 1.8'
        compute_resource ForemanDigitalocean::Digitalocean
        parameter_filter ComputeResource, :region, :api_key
      end
    end

    rake_tasks do
      load "#{ForemanDigitalocean::Engine.root}/lib/foreman_digitalocean/tasks/test.rake"
    end

    config.to_prepare do
      require 'fog/digitalocean'
      require 'fog/digitalocean/compute_v2'
      require 'fog/digitalocean/models/compute_v2/image'
      require 'fog/digitalocean/models/compute_v2/server'
      require File.expand_path(
        '../../../app/models/concerns/fog_extensions/digitalocean/server',
        __FILE__)
      require File.expand_path(
        '../../../app/models/concerns/fog_extensions/digitalocean/image',
        __FILE__)

      Fog::Compute::DigitalOceanV2::Image.send :include,
        FogExtensions::DigitalOcean::Image
      Fog::Compute::DigitalOceanV2::Server.send :include,
        FogExtensions::DigitalOcean::Server
      ::Host::Managed.send :include,
        ForemanDigitalocean::Concerns::HostManagedExtensions
    end
  end
end
