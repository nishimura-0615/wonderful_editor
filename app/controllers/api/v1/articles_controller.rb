module Api::V1
  class ArticlesController < BaseApiController
    def index
      articles = Article.all
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end
  end
end
