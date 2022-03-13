require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  let(:current_user) { create(:user) }
  let(:headers) { current_user.create_new_auth_token }

  describe "GET /api/v1/current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }

    let(:headers) { current_user.create_new_auth_token }
    let(:current_user) { create(:user) }

    context "複数の記事が存在するとき" do
      let!(:article1) { create(:article, :published, user: current_user, updated_at: 2.days.ago) }
      let!(:article2) { create(:article, :published, user: current_user, updated_at: 1.days.ago) }
      let!(:article3) { create(:article, :published, user: current_user) }

      it "自分が書いた公開済みの記事一覧を取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res["data"].length).to eq(3)
        expect(res["data"][0].keys).to eq ["id", "type", "attributes", "relationships"]
        expect(res["data"][0]["relationships"]["user"]["data"]["id"]).to eq current_user.id.to_s
        expect(article1).to be_published
        expect(article2).to be_published
        expect(article3).to be_published
      end
    end
  end
end
