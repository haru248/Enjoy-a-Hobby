require 'rails_helper'

RSpec.describe 'PasswordResets', type: :system do
  describe 'パスワード再発行' do
    context 'パスワードを忘れた方ページ' do
      before { visit new_password_reset_path }
      context '存在するユーザーのメールアドレスが入力' do
        let!(:user) { create(:user) }
        before do 
          fill_in 'email', with: user.email
          click_button '送信'
        end
        context 'パスワード変更用メールが送信される' do
          context 'パスワードとパスワード確認に入力された内容が同じ' do
            it 'パスワードの変更に成功する' do
              reset_user = User.find(user.id)
              url = edit_password_reset_url(reset_user.reset_password_token)
              delete_url = 'http://www.example.com'
              url.sub!(delete_url,'')
              visit url
              fill_in 'user_password', with: 'test_pass'
              fill_in 'user_password_confirmation', with: 'test_pass'
              click_button '更新'
              expect(current_path).to eq login_path
              expect(page).to have_content 'パスワードを変更しました'
              visit login_path
              fill_in 'email', with: user.email
              fill_in 'password', with: 'test_pass'
              click_button 'ログイン'
              expect(current_path).to eq mypage_path
              expect(page).to have_content 'ログインしました'
            end
          end
          context 'パスワードとパスワード確認に入力された内容が異なる' do
            it 'パスワードの変更に失敗する' do
              reset_user = User.find(user.id)
              url = edit_password_reset_url(reset_user.reset_password_token)
              delete_url = 'http://www.example.com'
              url.sub!(delete_url,'')
              visit url
              fill_in 'user_password', with: 'test_pass'
              fill_in 'user_password_confirmation', with: 'password'
              click_button '更新'
              expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
            end
          end
        end
      end
      context '存在しないユーザーのメールアドレスが入力' do
        it 'メールが送信されない' do
          fill_in 'email', with: 'no_email@email.com'
          click_button '送信'
          expect(page).to have_content 'パスワード変更用メールを送信しました'
          password_reset_mail = ActionMailer::Base.deliveries.last
          expect(password_reset_mail).to be nil
        end
      end
    end
  end
end