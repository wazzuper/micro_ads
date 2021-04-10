# frozen_string_literal: true

RSpec.describe AdRoutes, type: :routes do
  let(:user_id) {123 }
  let(:city) { 'Moscow' }
  let(:body) do
    {
      lat: 43.123123,
      lon: 12.312343,
    }
  end

  describe 'GET /v1' do
    before { create_list(:ad, 3, user_id: user_id) }

    it 'returns a collection of ads' do
      get '/v1'

      expect(last_response.status).to eq(200)
      expect(response_body['data'].size).to eq(3)
    end
  end

  describe 'POST /v1' do
    before do
      allow(Auth::Client).to receive(:new).and_return(auth_client)
      allow(auth_client).to receive(:auth).with(auth_token).and_return(user_id)

      header 'Authorization', "Bearer #{auth_token}"

      allow(Geocoder::Client).to receive(:new).and_return(geocoder_client)
      allow(geocoder_client).to receive(:geocode).with(city).and_return(body)
    end

    let(:auth_token) { 'auth_token' }
    let(:auth_client) { instance_double('Auth lib') }
    let(:geocoder_client) { instance_double('Geocoder lib') }

    context 'missing parameters' do
      it 'returns an error' do
        post '/v1'

        expect(last_response.status).to eq(422)
      end
    end

    context 'missing user_id' do
      let(:user_id) { nil }
      let(:ad_params) do
        {
          title: 'Ad title',
          description: 'Ad description',
          city: city,
        }
      end

      it 'returns an error' do
        post '/v1', ad: ad_params

        expect(last_response.status).to eq(403)
        expect(response_body['errors']).to include('detail' => 'Access denied')
      end
    end

    context 'invalid parameters' do
      let(:ad_params) do
        {
          title: 'Ad title',
          description: 'Ad description',
          city: ''
        }
      end

      it 'returns an error' do
        post '/v1', ad: ad_params

        expect(last_response.status).to eq(422)
        expect(response_body['errors']).to include(
          {
            'detail' => 'Add city',
            'source' => {
              'pointer' => '/data/attributes/city'
            }
          }
        )
      end
    end

    context 'valid parameters' do
      let(:ad_params) do
        {
          title: 'Ad title',
          description: 'Ad description',
          city: city,
        }
      end
      let(:last_ad) { Ad.last }

      it 'creates a new ad' do
        expect { post '/v1', ad: ad_params }.to change(Ad, :count)
        expect(last_response.status).to eq(201)
      end

      it 'returns ad' do
        post '/v1', ad: ad_params

        expect(response_body['data']).to a_hash_including('id' => last_ad.id.to_s, 'type' => 'ad')
      end
    end
  end
end
