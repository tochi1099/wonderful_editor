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
end
