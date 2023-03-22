require 'rails_helper'

RSpec.describe Preset, type: :model do
  describe 'のバリデーションが' do
    it 'すべてのアトリビュートに適用されない' do
      preset = build(:preset)
      expect(preset).to be_valid
      expect(preset.errors).to be_empty
    end
    it 'プリセット名がない場合に適用される' do
      name_less_preset = build(:preset, preset_name: '')
      expect(name_less_preset).not_to be_valid
      expect(name_less_preset.errors).not_to be_empty
    end
  end
end