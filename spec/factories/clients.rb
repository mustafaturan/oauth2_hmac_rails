FactoryGirl.define do 
  factory :client, class: Oauth2HmacRails::Client do
    id '12345678876543211234567887654321'
    mac_key 'demo_key'
    mac_algorithm 'hmac-sha-256'
    mac_request_expires_in 3
  end
end