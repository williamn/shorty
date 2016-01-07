require 'rails_helper'

RSpec.describe 'Shorty', type: :request do
  def response_body
    JSON.parse(response.body)
  end

  describe 'POST /shorten' do
    let(:headers) {{ 'accept' => 'application/json', 'content_type' => 'application/json' }}

    context 'when params valid' do
      it 'generates random shortcode' do
        body = {'url': 'http://example.com'}

        post '/shorten', body, headers

        expect(response).to have_http_status(201)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'when shortcode is not exist' do
      it 'generates desired shortcode' do
        body = {'url': 'http://example.com', 'shortcode': 'example'}

        post '/shorten', body, headers

        expect(response).to have_http_status(201)
        expect(response.content_type).to eq('application/json')
        expect(response_body['shortcode']).to eq('example')
      end
    end

    context 'when shortcode exist' do
      it 'respond with 409' do
        body = {'url': 'http://example.com', 'shortcode': 'example'}

        post '/shorten', body, headers

        expect(response).to have_http_status(409)
      end
    end

    context 'when url is not present' do
      it 'respond with 400' do
        body = nil

        post '/shorten', body, headers

        expect(response).to have_http_status(400)
      end
    end

    context 'when shortcode invalid' do
      it 'respond with 422' do
        body = {'url': 'http://example.com', 'shortcode': 'example!'}

        post '/shorten', body, headers

        expect(response).to have_http_status(422)
      end
    end
  end
end
