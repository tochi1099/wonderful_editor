require "rails_helper"

RSpec.describe Comment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

    context " コメントが記入しているとき " do
      it " コメントが作成される　" do
        comment = FactoryBot.build(:comment)
        expect(comment).to be_valid
      end
    end

    context " コメントが何も記入されていないとき " do
      it " エラーする " do
       comment = FactoryBot.build(:comment, body: nil)
       expect(comment).to be_invalid
       expect(comment.errors.details[:body][0][:error])
      end
    end

end
