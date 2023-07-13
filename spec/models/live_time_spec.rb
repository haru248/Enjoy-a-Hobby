require 'rails_helper'

RSpec.describe LiveTime, type: :model do
  describe 'のバリデーションが' do
    it 'すべてのアトリビュートに適用されない' do
      live_time = build(:live_time)
      expect(live_time).to be_valid
      expect(live_time.errors).to be_empty
    end
  end
end