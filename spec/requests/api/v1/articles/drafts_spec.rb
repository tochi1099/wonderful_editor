require "rails_helper"

RSpec.describe "Api::V1::Article::Drafts", type: :request do
  let(:current_user) { create(:user) }
  let(:headers) { current_user.create_new_auth_token }

  describe "GET /api/v1/articles/drafts" do
    subject { get(api_v1_articles_drafts_path, headers: headers) }

    context "自分の書いた下書きの記事が存在するとき" do
      let!(:article) { create(:article, :draft, user: current_user) }

      it " 下書きの記事の一覧を取得する事ができる " do
        subject
        res = JSON.parse(response.body)
        expect(res.length).to eq(1)
        expect(response).to have_http_status(:ok)
        expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "status", "user"]
        expect(article).to be_draft
      end
    end
  end

  describe "GET /api/v1/articles/draft/:id" do
    subject { get(api_v1_articles_draft_path(article_id), headers: headers) }

    context "指定した id の記事が存在して" do
      let(:article_id) { article.id }

      context "対象の記事が自分が書いた下書きのとき" do
        let(:article) { create(:article, :draft, user: current_user) }

        it "記事の詳細を取得できる" do
          subject
          res = JSON.parse(response.body)
          expect(res["id"]).to eq article.id
          expect(res["title"]).to eq article.title
          expect(res["body"]).to eq article.body
          expect(res["updated_at"]).to be_present
          expect(res["status"]).to eq article.status
          expect(response).to have_http_status(:ok)
        end
      end

      context "対象の記事が他人が書いた下書きのとき" do
        let(:article) { create(:article, :draft) }
        it "エラーする" do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
