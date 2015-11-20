Rails.application.routes.draw do

  mount Oauth2HmacRails::Engine => "/oauth2_hmac_rails"
end
