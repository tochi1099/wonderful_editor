require "rails_helper"

RSpec.describe Article, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

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
        expect(article.errors.details[:body][0][:error])
      end
    end

    context " タイトルが記入されていない時 " do
      it " エラーする " do
        article = FactoryBot.build(:article, title: nil)
        expect(article).to be_invalid
        expect(article.errors.details[:title][0][:error])
      end
    end

end
