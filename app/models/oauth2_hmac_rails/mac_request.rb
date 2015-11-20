module Oauth2HmacRails
  class MacRequest < ActiveRecord::Base
    include ::Oauth2HmacRails::Concerns::AutoId
  end
end
