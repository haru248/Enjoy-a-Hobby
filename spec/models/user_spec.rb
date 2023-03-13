require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'のバリデーションが' do
    it 'すべてのアトリビュートに適用されない' do
      user = build(:user)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end
    it 'ユーザーネームがない場合に適用される' do
      name_less_user = build(:user, user_name: '')
      expect(name_less_user).not_to be_valid
      expect(name_less_user.errors).not_to be_empty
    end
    it 'メールアドレスがない場合に適用される' do
      email_less_user = build(:user, email: '')
      expect(email_less_user).not_to be_valid
      expect(email_less_user.errors).not_to be_empty
    end
    it 'メールアドレスに重複がある場合に適用される' do
      user = create(:user, email: 'test@test')
      same_email_user = build(:user, email: 'test@test')
      expect(same_email_user).not_to be_valid
      expect(same_email_user.errors).not_to be_empty
    end
    it 'パスワードがない場合に適用される' do
      password_less_user = build(:user, password: '')
      expect(password_less_user).not_to be_valid
      expect(password_less_user.errors).not_to be_empty
    end
    it 'パスワードが3文字以下の場合に適用される' do
      password_3word_user = build(:user, password: 'aaa')
      expect(password_3word_user).not_to be_valid
      expect(password_3word_user.errors).not_to be_empty
    end
    it 'パスワード確認がない場合に適用される' do
      password_confirmation_less_user = build(:user, password_confirmation: '')
      expect(password_confirmation_less_user).not_to be_valid
      expect(password_confirmation_less_user.errors).not_to be_empty
    end
    it 'パスワードとパスワード確認が違う場合に適用される' do
      password_missing_user = build(:user, password: 'password', password_confirmation: 'miss_password')
      expect(password_missing_user).not_to be_valid
      expect(password_missing_user.errors).not_to be_empty
    end
  end
end
