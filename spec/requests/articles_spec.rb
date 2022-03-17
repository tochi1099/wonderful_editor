require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe " GET api/v1/articles " do
    subject { get(api_v1_articles_path) }

    # statusをpublished（公開）にしたものとdraft（下書き）にしたものを作成し、publishedのものだけを取得するようにテスト
    let!(:article1) { create(:article, :published, updated_at: 2.days.ago) }
    let!(:article2) { create(:article, :published, updated_at: 1.days.ago) }
    let!(:article3) { create(:article, :published) }

    before { create(:article, :draft) }

    it "公開している記事の一覧が取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(res.length).to eq(3)
      expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "status", "user"]
      expect(res.map {|d| d["id"] }).to eq [article3.id, article2.id, article1.id]
    end
  end

  describe "Get api/v1/articles/:id " do
    subject { get(api_v1_article_path(article_id)) }

    let(:article_id) { article.id }

    context "指定した id の記事が存在して" do
      let(:article_id) { article.id }

      context "指定した id の記事のデータが存在し、その記事が公開済みの場合" do
        let(:article) { create(:article, :published) }

        it "記事の詳細を取得できる" do
          subject
          res = JSON.parse(response.body)
          expect(res["id"]).to eq article.id
          expect(res["title"]).to eq article.title
          expect(res["body"]).to eq article.body
          expect(res["updated_at"]).to be_present
          expect(res["user"]["id"]).to eq article.user.id
          expect(res["user"].keys).to eq ["id", "name", "email"]
        end
      end

      context "指定した id が存在しない時" do
        let(:article_id) { 1_000_000 }

        it "記事は取得できない" do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context "記事が下書きの場合" do
      let(:article) { create(:article, :draft) }
      it "記事の詳細を取得できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "POST /api/v1/articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    context "公開する記事を作成するとき" do
      let(:params) { { article: attributes_for(:article, :published) } }

      it "公開する記事のレコードが作成される" do
        expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(response).to have_http_status(:ok)
      end
    end

    context "記事が下書き状態のとき" do
      let(:params) { { article: attributes_for(:article, :draft) } }
      it "下書きの記事が作成される" do
        expect { subject }.to change { Article.count }.by(1)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(response).to have_http_status(:ok)
      end
    end

    context "不適切なパラメーターが送信された時" do
      let(:params) { attributes_for(:article) }
      it "エラーする" do
        expect { subject }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    subject { patch(api_v1_article_path(article.id), params: params, headers: headers) }

    let(:params) { { article: attributes_for(:article, :published) } }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    context "自分が書いた記事のレコードを更新しようとしたとき" do
      # 更新しようとしているからまだ下書き状態。また自分の記事なのでログインしている
      let!(:article) { create(:article, :draft, user: current_user) }
      it "記事の内容を更新できる" do
        expect { subject }.to change { article.reload.body }.from(article.body).to(params[:article][:body]) &
                              change { article.reload.title }.from(article.title).to(params[:article][:title]) &
                              change { article.reload.status }.from(article.status).to(params[:article][:status])
        expect(response).to have_http_status(:ok)
      end
    end

    context "他人が書いた記事のレコードを更新しようとしたとき" do
      let(:other_user) { create(:user) }
      let(:article) { create(:article, user: other_user) }

      it "エラーする" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "DELETE /api/v1/articles/:id" do
    subject { delete(api_v1_article_path(article_id), headers: headers) }

    let(:article_id) { article.id }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    context "自分が書いた記事のレコードを削除しようとしたとき" do
      let!(:article) { create(:article, user: current_user) }

      it "記事を削除する事ができる" do
        expect { subject }.to change { Article.count }.by(-1)
      end
    end

    context "他人の書いた記事のレコードを削除しようとしたとき" do
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }

      it "エラーする" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
