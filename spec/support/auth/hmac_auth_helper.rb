require 'oauth2_hmac_header'

module HmacAuthHelper
  def authorize(header_key, client, method, uri, host, port, ext)
    header_key = rails_specific_headers_for_authorization(header_key)
    request.env[header_key] = generate_auth_header(client, method, uri, host, port, ext.is_a?(Hash) ? ext.to_query : ext)
  end

  private

  def rails_specific_headers_for_authorization(header_key)
    case header_key
    when 'Authorization'
      'HTTP_AUTHORIZATION'
    when 'X-Authorization'
      'X-HTTP_AUTHORIZATION'
    when 'X_Authorization'
      'X_HTTP_AUTHORIZATION'
    when 'Redirect_X_Authorization'
      'REDIRECT_X_HTTP_AUTHORIZATION'
    else
      header_key
    end
  end

  def generate_auth_header(client, method, uri, host, port, ext)
    Oauth2HmacHeader::AuthorizationHeader.generate_with_new_signature(
      client.id, 
      client.mac_algorithm, 
      client.mac_key, 
      method, uri, host, port, ext
    )
  end
end