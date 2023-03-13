require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "reset_password_email" do
    let!(:user) { create(:user) }
    subject!(:mail) do
      user.deliver_reset_password_instructions!
    end
    it 'パスワードリセット用メールが送信される' do
      expect(mail.to).to eq ["#{user.email}"]
      expect(mail.subject).to eq 'パスワード再発行'
      expect(mail.html_part.body.to_s).to include 'パスワード再発行のご依頼を受け付けました。'
    end
  end
end
