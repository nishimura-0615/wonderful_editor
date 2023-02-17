require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET articles" do
    subject { get(api_v1_articles_path) }

    context "3つの記事を作成するとき" do
      let!(:article1) { create(:article, updated_at: 1.days.ago) }
      let!(:article2) { create(:article, updated_at: 2.days.ago) }
      let!(:article3) { create(:article) }

      it "記事の一覧が取得できる" do
        subject
        res = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(res.length).to eq 3
        expect(res.map {|d| d["id"] }).to eq [article1.id, article2.id, article3.id]
        expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
        expect(res[0]["user"].keys).to eq ["id", "name", "email"]
      end
    end
  end

  describe "GET articles/:id" do
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

  describe "POST articles" do
    subject { post(api_v1_articles_path, params: params) }

    context "ログインユーザーが適切なパラメーターを送信したとき" do
      let(:current_user) { create(:user) }
      let(:params) { { article: attributes_for(:article) } }
      # この記述は後の実装で記述を修正する予定なので現状は rubocop:disable all で対応
      before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) } # rubocop:disable all

      it "記事のレコードが作成される" do
        expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログインしていないユーザーがパラメーターを送信したとき" do
      let(:params) { { article: attributes_for(:article) } }
      it "エラーする" do
        expect { subject }.to raise_error(NoMethodError)
      end
    end
  end

  describe "PATCH（PUT) /articles/:id" do
    subject { patch(api_v1_article_path(article.id), params: params) }

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }
    before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) } # rubocop:disable all

    context "自分で作成している記事のレコードを更新をするとき" do
      let(:article) { create(:article, user: current_user) }
      it "記事を更新できる" do
        expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title]) &
                              change { article.reload.body }.from(article.body).to(params[:article][:body])
        expect(response).to have_http_status(:ok)
      end
    end

    context "自分以外の人が作成している記事のレコードを更新をするとき" do
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }
      it "更新できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
