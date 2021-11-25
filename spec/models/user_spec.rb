require "rails_helper"

RSpec.describe User, type: :model do
  context " 全ての条件が揃っている時 " do
    it " ユーザーが作られる " do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end
  end

  context " name を指定していない時 " do
    it " エラーする " do
      user = FactoryBot.build(:user, name: nil)
      expect(user).to be_invalid
    end
  end

  context " すでに同じ名前の name が存在している時 " do
    it " エラーする " do
      FactoryBot.create(:user, name: "foo")
      user = FactoryBot.build(:user, name: "foo")
      expect(user).to be_invalid
    end
  end

  context " email を指定していない時" do
    it " エラーする " do
      user = FactoryBot.build(:user, email: nil)
      expect(user).to be_invalid
    end
  end

  context " すでに同じ名前の email が存在している時" do
    it " エラーする " do
      FactoryBot.create(:user, email: "foo@example.com")
      user = FactoryBot.build(:user, email: "foo@example.com")
      expect(user).to be_invalid
    end
  end

  context " password を指定していない時" do
    it " エラーする " do
      user = FactoryBot.build(:user, password: nil)
      expect(user).to be_invalid
    end
  end
end
