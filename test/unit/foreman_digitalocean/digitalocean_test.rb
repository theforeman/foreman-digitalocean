require 'test_plugin_helper'

module ForemanDigitalocean
  class DigitaloceanTest < ActiveSupport::TestCase
    should validate_presence_of(:api_key)
    should have_one(:key_pair)

    setup { Fog.mock! }
    teardown { Fog.unmock! }

    test 'ssh key pair gets created after its saved' do
      digitalocean = FactoryGirl.build(:digitalocean_cr)
      digitalocean.expects(:setup_key_pair)
      digitalocean.save
    end
  end
end
