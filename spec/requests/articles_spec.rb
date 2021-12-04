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

    # fit "記事の本文が含まれている" do
    #   binding.pry
    #   expext(article).to be_invalid

    # end
  end

  describe "Get api/v1/articles/:id " do
    subject { get(api_v1_article_path(article_id)) }

    context "指定した id の記事が存在する場合" do
      let(:article_id) { article.id }
      let(:article) { create(:article) }

      it "記事の詳細を取得できる" do
        subject
        res = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
      end
    end

    context "指定した id が存在しない時" do
      let(:article_id) { 1_000_000 }

      it "記事は取得できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
