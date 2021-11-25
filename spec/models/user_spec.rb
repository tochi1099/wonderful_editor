require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

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
      expect(user.errors.details[:name][0][:error]).to eq :blank
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
      expect(user.errors.details[:email][0][:error])
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
      expect(user.errors.details[:password][0][:error])
    end
  end

end
