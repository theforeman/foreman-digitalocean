FactoryBot.define do
  factory :container_resource, :class => ComputeResource do
    sequence(:name) { |n| "compute_resource#{n}" }

    trait :digitalocean do
      provider 'Digitalocean'
      api_key 'asampleapikey'
      region 'everywhere'
    end

    factory :digitalocean_cr, :class => ForemanDigitalocean::Digitalocean, :traits => [:digitalocean]
  end
end
