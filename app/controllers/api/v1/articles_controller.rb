module Api::V1
  class ArticlesController < Api::V1::BaseApiController

    def index
      articles = Article.order(updated_at: "DESC")
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      article = Article.find(params[:id])
      render json: article, serializer: Api::V1::ArticleSerializer
    end

    def create
      # binding.pry
      # article = Article.new(article_params)
      # article.user_id = current_user.id
      article = current_user.articles.create!(article_params)

      # article.save!
      render json: article, serializer: Api::V1::ArticleSerializer
    end

    private
      def article_params
        params.require(:article).permit(:title, :body)
      end
  end
end
