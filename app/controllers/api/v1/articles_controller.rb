module Api::V1
  class ArticlesController < BaseApiController
    def index
      articles = Article.order(updated_at: "DESC")
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      articles = Article.find(params[:id])
      render json: articles, erializer: Api::V1::ArticlePreviewSerializer
    end
  end
end
