module ForemanDigitalocean
  module Concerns
    module HostManagedExtensions
      extend ActiveSupport::Concern

      included do
        # Rails 4 does not provide dynamic finders for delegated methods and
        # the SSH orchestrate compute method uses them.
        def self.find_by_ip(ip)
          nic = Nic::Base.find_by_ip(ip)
          nic.host if nic.present?
        end
      end
    end
  end
end
