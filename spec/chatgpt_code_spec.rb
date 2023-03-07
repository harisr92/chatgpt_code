# frozen_string_literal: true

RSpec.describe ChatgptCode do
  it 'has a version number' do
    expect(ChatgptCode::VERSION).not_to be nil
  end

  describe '.configure' do
    it 'respond to configure' do
      expect(ChatgptCode).to respond_to(:config)
      expect(ChatgptCode).to respond_to(:configure)
    end

    context 'configuration settings' do
      subject { ChatgptCode.config }

      it { is_expected.to respond_to(:api_key) }
      it { is_expected.to respond_to(:logger) }
    end
  end
end
