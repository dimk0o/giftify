require 'rails_helper'

RSpec.describe TelegramBotController, telegram_bot: :rails, type: :request do
  let!(:user) { create :user }

  before { sign_in user }

  describe '#start!' do
    subject { -> { dispatch_command :start } }

    context "when logged" do
      before do
        dispatch_command :start
        dispatch_message ''
      end

      it { is_expected.to respond_with_message 'Click on the button below to connect to your Giftify account' }
    end

    context "when not logged" do
      before do
        dispatch_command :start
      end

      it { is_expected.to respond_with_message 'Click on the button below to connect to your Giftify account' }

      it 'successfully connected to telegram' do
        telegram_profile = TelegramProfile.last
        expect(bot.requests[:sendMessage].last[:reply_markup]).to eq inline_keyboard: [
            [
              { text: "Connect",
                url: "http://www.#{Rails.application.routes.default_url_options[:host]}/account/telegram_profile/connect?connection_token=#{telegram_profile.connection_token}" }
            ]
          ]
        get account_telegram_profile_connect_path(connection_token: telegram_profile.connection_token)
        follow_redirect!
        expect(response.body).to include('You`re connected to telegram')
        expect(bot.requests[:sendMessage].last[:text]).to eq 'You are connected to giftify successfully'
      end
    end
  end

  describe '#disconnect!' do
    subject { -> { dispatch_command :disconnect } }

    context "when not logged" do
      before do
        dispatch_command :disconnect
      end

      it { is_expected.to respond_with_message 'You are disconnected from your giftify account' }
    end
  end

  describe '#balance!' do
    subject { -> { dispatch_command :balance } }

    context "when not logged" do
      before do
        dispatch_command :balance
      end

      it { is_expected.to respond_with_message 'You couldn`t watch your balance unless you are not authorized' }
    end
  end
end
