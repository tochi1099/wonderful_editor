require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe " GET api/v1/articles " do
    subject { get(api_v1_articles_path) }

    before { create_list(:article, 3) }

    it "記事の一覧が取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(res["data"].length).to eq(3)
      expect(res["data"][0].keys).to eq ["id", "type", "attributes", "relationships"]
    end


  end

  describe "Get api/v1/articles/:id " do
    subject { get(api_v1_article_path(article_id)) }
    let(:article_id) { article.id }
    let(:article) { create(:article) }

    context "指定した id の記事のデータが存在する場合" do

      # let(:article_id) { article.id }
      # let(:article) { create(:article) }


      it "記事の詳細を取得できる" do
        subject

        res = JSON.parse(response.body)

        # expect(res["data"]["id"]).to eq article.id
        expect(res["data"]["attributes"]["title"]).to eq article.title
        expect(res["data"]["attributes"]["body"]).to eq article.body
        expect(res["data"]["attributes"]["updated-at"]).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context "指定した id が存在しない時" do
      let(:article_id) { 1_000_000 }

      it "記事は取得できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "POST /api/v1/articles" do
    subject { post(api_v1_articles_path, params: params)}

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }

    before{ allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }

    context "適切なパラメーターが送信された時" do


      it "ユーザーのレコードが作成される" do

        expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
        res = JSON.parse(response.body)
        expect(res["data"]["attributes"]["title"]).to eq params[:article][:title]
        expect(res["data"]["attributes"]["body"]).to eq params[:article][:body]
        expect(response).to have_http_status(:ok)
      end
    end

    context "不適切なパラメーターが送信された時" do
      let(:params) { attributes_for(:article) }
      fit "エラーする" do
        expect { subject }.to raise_error(ActionController::ParameterMissing)
      end
    end

  end
end
