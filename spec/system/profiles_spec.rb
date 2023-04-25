require 'rails_helper'

RSpec.describe 'Profiles', type: :system do
  describe 'プロフィール編集' do
    let!(:user) { create(:user) }
    before { login(user) }
    context 'プロフィール編集ページ' do
      before { visit edit_profile_path }
      context 'フォームの入力値が正常' do
        it 'プロフィール編集に成功する' do
          fill_in 'user_user_name', with: 'test_user_update'
          fill_in 'user_email', with: 'update_test@test'
          click_button '更新'
          expect(current_path).to eq profile_path
          expect(page).to have_content 'test_user_update'
          expect(page).to have_content 'update_test@test'
          expect(page).to have_content 'ユーザー情報を変更しました'
        end
      end
      context 'ユーザーネームが未入力' do
        it 'プロフィール編集に失敗する' do
          fill_in 'user_user_name', with: ''
          fill_in 'user_email', with: 'update_test@test'
          click_button '更新'
          expect(current_path).to eq profile_path
          expect(page).to have_content 'ユーザーネームを入力してください'
          expect(page).to have_content 'ユーザー情報の編集に失敗しました'
        end
      end
      context 'メールアドレスが未入力' do
        it 'プロフィール編集に失敗する' do
          fill_in 'user_user_name', with: 'test_user_update'
          fill_in 'user_email', with: ''
          click_button '更新'
          expect(current_path).to eq profile_path
          expect(page).to have_content 'メールアドレスを入力してください'
          expect(page).to have_content 'ユーザー情報の編集に失敗しました'
        end
      end
    end
    context 'パスワード変更ページ' do
      before { visit password_reset_profile_path }
      context 'パスワード変更用メールの送信' do
        it 'パスワード変更用メールの送信がされる' do
          expect(page).to have_content user.email
          click_on '送信'
          expect(current_path).to eq mypage_path
          expect(page).to have_content 'パスワード変更用メールを送信しました'
          password_reset_mail = ActionMailer::Base.deliveries.last
          expect(password_reset_mail).not_to be nil
        end
      end
    end
    context 'アカウント削除' do
      let!(:preset) { create(:preset, user: user) }
      let!(:inventory_list) { create(:inventory_list, user: user) }
      let!(:purchase_list) { create(:purchase_list, user: user) }
      it 'プロフィール詳細ページでアカウント削除をクリックした場合アカウントが削除される' do
        visit profile_path
        click_on 'アカウント削除'
        expect(page.accept_confirm).to eq 'アカウント削除後、アカウントの復旧はできません。本当に削除してもよろしいですか?'
        expect(current_path).to eq root_path
        expect(page).not_to have_content 'プロフィール'
        expect(page).not_to have_content 'ログアウト'
        expect(page).to have_content 'ユーザー登録'
        expect(page).to have_content 'ログイン'
        expect(Preset.find_by(id: preset.id)).to be nil
        expect(InventoryList.find_by(id: inventory_list.id)).to be nil
        expect(PurchaseList.find_by(id: purchase_list.id)).to be nil
      end
    end
  end
end
