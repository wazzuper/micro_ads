# frozen_string_literal: true

RSpec.describe Auth::Http::Client, type: :client do
  subject { described_class.new(connection: connection) }

  before { stubs.post('auth') { [status, headers, body.to_json] } }

  let(:status) { 200 }
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:body) { {} }

  describe "#auth" do
    context 'when token is valid' do
      let(:user_id) { 123 }
      let(:body) { { 'meta' => { 'user_id' => user_id } } }
      let(:token) { 'valid_token' }

      it { expect(subject.auth(token)).to eq(user_id) }
    end

    context "when token is invalid" do
      let(:status) { 403 }
      let(:token) { 'invalid_token' }

      it { expect(subject.auth(token)).to eq(nil) }
    end

    context "when token is nil" do
      let(:status) { 403 }
      let(:token) { nil }

      it { expect(subject.auth(token)).to eq(nil) }
    end
  end
end
