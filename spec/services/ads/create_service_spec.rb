# frozen_string_literal: true

RSpec.describe Ads::CreateService do
  subject { described_class }

  context 'valid parameters' do
    before do
      allow(Geocoder::Http::Client).to receive(:new).and_return(client)
      allow(client).to receive(:geocode).with(city).and_return(body)
    end

    let(:client) { instance_double('Geocoder lib') }
    let(:city) { 'Moscow' }
    let(:body) do
      {
        lat: 43.123123,
        lon: 12.312343,
      }
    end
    let(:ad_params) do
      {
        title: 'Ad title',
        description: 'Ad description',
        city: city,
      }
    end
    let(:user_id) { 123 }
    let(:ad) { Ad.last }

    it 'creates ad' do
      expect { subject.call(ad_params, user_id: user_id) }.to change(Ad, :count)
      expect(ad.reload.lat).to eq(body[:lat])
      expect(ad.reload.lon).to eq(body[:lon])
    end

    it 'assigns ad' do
      result = subject.call(ad_params, user_id: user_id)

      expect(result.ad).to be_kind_of(Ad)
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
    let(:user_id) { 123 }

    it { expect { subject.call(ad_params, user_id: user_id) }.not_to change(Ad, :count) }

    it 'assigns ad' do
      result = subject.call(ad_params, user_id: user_id)

      expect(result.ad).to be_kind_of(Ad)
    end
  end
end
