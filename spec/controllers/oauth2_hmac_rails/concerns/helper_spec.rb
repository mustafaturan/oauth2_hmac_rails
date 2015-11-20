require 'rails_helper'

module Oauth2HmacRails

  class FoosController < ApplicationController; end

  RSpec.describe Concerns::Helper do
    # fake controller
    controller FoosController do
      include ::Oauth2HmacRails::Concerns::Helper
      before_action :authorize!

      def client_authorization_header_key
        'Oauth2_Hmac_Rails'
      end

      def custom
        render json: { status: 'ok' }, status: :ok
      end
    end

    let(:client) { create(:client) }
    let(:header_key) { 'Oauth2_Hmac_Rails' }

    before {
      routes.draw { get '/custom' => 'oauth2_hmac_rails/foos#custom' }
      routes.draw { post '/custom' => 'oauth2_hmac_rails/foos#custom' }
    }

    describe '.authorize!' do
      context 'unauthorized requests' do
        it 'has missing hmac key' do
          authorize(header_key, client, 'GET', "/custom", request.host, request.port, nil)
          request.env[header_key] = request.env[header_key].gsub(/(nonce=\"[^"]+)\"/, '')
          get :custom
          expect(response.body).to include "MISSING_HMAC_KEY"
          expect(response).to have_http_status(:unauthorized)
        end

        it 'has blank required hmac key' do
          authorize(header_key, client, 'GET', "/custom", request.host, request.port, nil)
          request.env[header_key] = request.env[header_key].gsub(/(mac=\"[^"]+)/, 'mac="')
          get :custom
          expect(response.body).to include "MISSING_HMAC_KEY"
          expect(response).to have_http_status(:unauthorized)
        end

        it 'client not found' do
          client.id = "laylaylom"
          authorize(header_key, client, 'GET', "/custom", request.host, request.port, nil)
          get :custom
          expect(response.body).to include "CLIENT_NOT_FOUND"
          expect(response).to have_http_status(:unauthorized)
        end

        it 'invalid signature' do
          authorize(header_key, client, 'GET', "/custom?invalid=1", request.host, request.port, nil)
          get :custom
          expect(response.body).to include "INVALID_SIGNATURE"
          expect(response).to have_http_status(:unauthorized)
        end

        it 'request timeout for signature' do
          authorize(header_key, client, 'GET', "/custom", request.host, request.port, nil)
          sleep(client.mac_request_expires_in + 1)
          get :custom
          expect(response.body).to include "REQUEST_TIMEOUT_FOR_CLIENT_SIGNATURE"
          expect(response).to have_http_status(:unauthorized)
        end
        
        it 'replay attack' do
          authorize(header_key, client, 'GET', "/custom", request.host, request.port, nil)
          get :custom
          get :custom
          expect(response.body).to include "REPLAY_ATTACK"
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'authorized request' do
        it 'sends a authorizable get request' do
          authorize(header_key, client, 'GET', "/custom", request.host, request.port, nil)
          get :custom
          expect(response.body).to eq "{\"status\":\"ok\"}"
          expect(response).to have_http_status(:ok)
        end

        it 'sends a authorizable post request' do
          authorize(header_key, client, 'POST', "/custom", request.host, request.port, { fake: 'custom data' })
          post :custom
          expect(response.body).to eq "{\"status\":\"ok\"}"
          expect(response).to have_http_status(:ok)
        end
      end
    end

  end
  
end
