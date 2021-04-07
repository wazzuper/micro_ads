# frozen_string_literal: true

RSpec.describe Ads::CreateService do
  subject { described_class }

  context 'valid parameters' do
    let(:ad_params) do
      {
        title: 'Ad title',
        description: 'Ad description',
        city: 'City',
      }
    end
    let(:user_id) { 123 }

    it { expect { subject.call(ad_params, user_id: user_id) }.to change(Ad, :count) }

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
