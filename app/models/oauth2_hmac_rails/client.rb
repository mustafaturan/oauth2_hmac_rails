require 'attr_encrypted'

module Oauth2HmacRails
  class Client < ActiveRecord::Base
    include ::Oauth2HmacRails::Concerns::AutoId
    attr_encrypted :mac_key, key: Rails.application.secrets.secret_key_base, encode: true
    serialize :settings, OpenStruct
  end
end
