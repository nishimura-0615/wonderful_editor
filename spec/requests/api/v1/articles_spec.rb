require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  #  describe "GET /articles" do
  #    subject { get(api_v1_articles_path) }

  #    before { create_list(:article, 3) }

  #    it "記事の一覧が取得できる" do
  #      subject

  #     res = JSON.parse(response.body)

  #      expect(response).to have_http_status(:ok)
  #      expect(res.length).to eq 3
  #      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
  #      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
  #     end
  #   end

  describe "GET /articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定した id の記事が存在する場合" do
      let(:article) { create(:article) }
      let(:article_id) { article.id }

      it "任意の記事の値が取得できる" do
        subject
        res = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["user"]["id"]).to eq article.user.id
        expect(res["user"].keys).to eq ["id", "name", "email"]
      end
    end

    context "指定した id の記事が存在しない場合" do
      let(:article_id) { 100000 }

      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
