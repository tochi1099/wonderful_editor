require "rails_helper"

RSpec.describe Article, type: :model do
  context " 全ての条件が揃っている時 " do
    it " 記事が作成される " do
      @user = FactoryBot.create(:user)
      article = FactoryBot.build(:article, user_id: @user.id)
      expect(article).to be_valid
    end
  end

  context " 記事が記入されていない時 " do
    it " エラーする " do
      article = FactoryBot.build(:article, body: nil)
      expect(article).to be_invalid
    end
  end

  context " タイトルが記入されていない時 " do
    it " エラーする " do
      article = FactoryBot.build(:article, title: nil)
      expect(article).to be_invalid
    end
  end
end
