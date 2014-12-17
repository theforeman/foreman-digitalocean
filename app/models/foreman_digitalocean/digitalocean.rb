module ForemanDigitalocean
  class Digitalocean < ComputeResource
    has_one :key_pair, :foreign_key => :compute_resource_id, :dependent => :destroy
    delegate :flavors, :to => :client

    validates :user, :password, :presence => true
    before_create :test_connection

    after_create :setup_key_pair
    after_destroy :destroy_key_pair


    # Not sure why it would need a url, but OK (copied from ec2)
    alias_attribute :region, :url

    def to_label
      "#{name} (#{provider_friendly_name})"
    end

    def provided_attributes
      super.merge({ :uuid => :identity_to_s, :ip => :public_ip_address })
    end

    def self.model_name
      ComputeResource.model_name
    end

    def capabilities
      [:image]
    end

    def find_vm_by_uuid(uuid)
      client.servers.get(uuid)
    rescue Fog::Compute::DigitalOcean::Error
      raise(ActiveRecord::RecordNotFound)
    end

    def create_vm(args = { })
      args["ssh_keys"] = [ssh_key] if ssh_key
      super(args)
    rescue Fog::Errors::Error => e
      logger.error "Unhandled DigitalOcean error: #{e.class}:#{e.message}\n " + e.backtrace.join("\n ")
      raise e
    end

    def available_images
      client.images
    end

    def regions
      return [] if user.blank? || password.blank?
      client.regions
    end

    def test_connection(options = {})
      super
      errors[:user].empty? and errors[:password].empty? and regions.count
    rescue Excon::Errors::Unauthorized => e
      errors[:base] << e.response.body
    rescue Fog::Errors::Error => e
      errors[:base] << e.message
    end

    def destroy_vm(uuid)
      vm = find_vm_by_uuid(uuid)
      vm.destroy if vm.present?
      true
    end

    # not supporting update at the moment
    def update_required?(old_attrs, new_attrs)
      false
    end

    def self.provider_friendly_name
      "DigitalOcean"
    end

    def associated_host(vm)
      Host.authorized(:view_hosts, Host).where(:ip => [vm.public_ip_address, vm.private_ip_address]).first
    end

    def user_data_supported?
      true
    end

    def default_region_name
      @default_region_name ||= client.regions.get(region.to_i).try(:name)
    rescue Excon::Errors::Unauthorized => e
      errors[:base] << e.response.body
    end

    private

    def client
      @client ||= Fog::Compute.new(
        :provider => "DigitalOcean",
        :digitalocean_client_id => user,
        :digitalocean_api_key => password,
      )
    end

    def vm_instance_defaults
      super.merge(
        :flavor_id => client.flavors.first.id
      )
    end


    # this method creates a new key pair for each new DigitalOcean compute resource
    # it should create the key and upload it to DigitalOcean
    def setup_key_pair
      public_key, private_key = generate_key
      key_name = "foreman-#{id}#{Foreman.uuid}"
      key = client.create_ssh_key key_name, public_key
      KeyPair.create! :name => key_name, :compute_resource_id => self.id, :secret => private_key
    rescue => e
      logger.warn "failed to generate key pair"
      logger.error e.message
      logger.error e.backtrace.join("\n")
      destroy_key_pair
      raise
    end

    def destroy_key_pair
      return unless key_pair
      logger.info "removing DigitalOcean key #{key_pair.name}"
      client.destroy_ssh_key(ssh_key.id) if ssh_key
      key_pair.destroy
      true
    rescue => e
      logger.warn "failed to delete key pair from DigitalOcean, you might need to cleanup manually : #{e}"
    end

    def ssh_key
      @ssh_key ||= begin
        key = client.list_ssh_keys.data[:body]["ssh_keys"].select{|i| i["name"] == key_pair.name}.first
        if key
          #the vm creator expects objects which respond to id, OpenStruct is the shortest solution.
          OpenStruct.new(key)
        else
          nil
        end
      end
    end

    def generate_key
      key = OpenSSL::PKey::RSA.new 2048
      type = key.ssh_type
      data = [ key.to_blob ].pack('m0')

      openssh_format_public_key = "#{type} #{data}"
      [openssh_format_public_key, key.to_pem]
    end

  end
end
