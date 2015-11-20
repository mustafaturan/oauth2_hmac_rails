# Oauth2HmacRails

[![Build Status](https://travis-ci.org/mustafaturan/oauth2_hmac_rails.png)](https://travis-ci.org/mustafaturan/oauth2_hmac_rails) [![Code Climate](https://codeclimate.com/github/mustafaturan/oauth2_hmac_rails.png)](https://codeclimate.com/github/mustafaturan/oauth2_hmac_rails)

A Ruby on Rails engine, simply generates, parse and verify signatures for Oauth v2 HTTP MAC authentication for 'SHA1' and 'SHA256' algorithms. Please visit https://tools.ietf.org/html/draft-ietf-oauth-v2-http-mac-01 for spec specifications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'oauth2_hmac_rails'
```

And then execute:

    $ bundle
    $ bundle exec rake oauth2_hmac_rails:install:migrations

## Usage

Include engine helper to your controller(line1) and call authorization helper method(line2)
```ruby

    class FoosController < ApplicationController
      include ::Oauth2HmacRails::Concerns::Helper # line1 / now current_client helper is accessible
      before_action :authorize! # line2

      # if you need to overwrite default authorization header define the method below
      # def client_authorization_header_key
      #   'Oauth2_Hmac_Rails' # desired header, default: 'Authorization'
      # end

      # sample action
      def custom
        render json: { message: "Authorization success for client #{current_client.id}." }, status: :ok
      end
    end

```

## Customize

Error messages can be customizable by I18n files.

```yaml

    en:
      oauth2_hmac_rails:
        missing_hmac_key: "MISSING_HMAC_KEY: %{details}"
        client_not_found: "CLIENT_NOT_FOUND: %{client_id}"
        invalid_signature: "INVALID_SIGNATURE: %{mac} for client id %{client_id}"
        request_timeout_for_client_signature: "REQUEST_TIMEOUT_FOR_CLIENT_SIGNATURE: #{mac} for client id #{client_id}"
        unauthorized: "UNAUTHORIZED"
        replay_attack: "REPLAY_ATTACK"

```

## Contributing

1. Fork it ( https://github.com/mustafaturan/oauth2_hmac_rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
