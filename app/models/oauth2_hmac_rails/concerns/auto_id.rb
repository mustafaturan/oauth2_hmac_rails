module Oauth2HmacRails
  module Concerns
    module AutoId
      extend ActiveSupport::Concern
    
      included do
        self.primary_key = 'id'
    
        before_create :generate_id
        def generate_id
          (self.id = SecureRandom.uuid.gsub('-', '')) if self.id.nil?
        end
      end
    
      class_methods do
      end
    end
  end
end