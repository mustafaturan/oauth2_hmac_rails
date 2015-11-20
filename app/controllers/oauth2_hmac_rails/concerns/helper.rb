require 'oauth2_hmac_header'
module Oauth2HmacRails
  module Concerns
    module Helper
      extend ActiveSupport::Concern
      included do
        AUTHORIZATION_DEFAULT_HEADER_KEY = 'Authorization'

        attr_accessor :client_authorization_header_key
        attr_reader :current_client

        def client_authorization_header_key
          AUTHORIZATION_DEFAULT_HEADER_KEY
        end

        def authorize!
          begin
            client_id, ts, nonce, ext, mac = ::Oauth2HmacHeader::AuthorizationHeader.parse(client_authorization_header)
          rescue KeyError => e
            return unauthorized I18n.t("oauth2_hmac_rails.missing_hmac_key", details: e)
          end

          # get client data
          begin
            @current_client = Client.find(client_id)
          rescue ActiveRecord::RecordNotFound
            return unauthorized I18n.t("oauth2_hmac_rails.client_not_found", client_id: client_id)
          end

          # validate signature
          begin
            validity_flag = ::Oauth2HmacHeader::AuthorizationHeader.is_valid?(
              mac,
              @current_client.mac_algorithm,
              @current_client.mac_key,
              ts,
              nonce,
              request.method,
              request.path,
              request.host,
              request.port,
              ext
            )
            return unauthorized I18n.t("oauth2_hmac_rails.invalid_signature", mac: mac, client_id: client_id) unless validity_flag
            return unauthorized I18n.t("oauth2_hmac_rails.request_timeout_for_client_signature", mac: mac, client_id: client_id) if (ts.to_i + @current_client.mac_request_expires_in) < Time.now.to_i # request timeout
          rescue
            return unauthorized I18n.t("oauth2_hmac_rails.unauthorized")
          end

          # add valid request to db for preventing replay attacks and api analytics
          create_mac_request(client_id, ts, nonce, ext, mac)
        end

        private

        def client_authorization_header
          request.headers[client_authorization_header_key].to_s
        end

        def unauthorized(reason)
          logger.info "#{self.class.name} / #{reason}"
          attach_unauthorized_header
          render(json: { error: reason }, status: :unauthorized) and return false
        end

        def attach_unauthorized_header
          response.headers['WWW-Authenticate'] = 'MAC'
        end

        def create_mac_request(client_id, ts, nonce, ext, mac)
          begin
            MacRequest.create(
              ip: request.ip,
              method: request.method,
              uri: request.path,
              host: request.host,
              port: request.port,
              client_id: client_id,
              ts: ts,
              nonce: nonce,
              ext: ext.to_s,
              mac: mac,
              uts: Time.now.to_i
            )
          rescue ActiveRecord::RecordNotUnique
            return unauthorized I18n.t("oauth2_hmac_rails.replay_attack")
          end
        end
      end
    end
  end
end
