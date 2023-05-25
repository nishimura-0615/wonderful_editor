# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  status     :string           default("draft")
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Article, type: :model do
  context "タイトルと本文に文字が入力されているとき" do
    let(:article) { build(:article) }
    it "記事が作成される" do
      expect(article).to be_valid
    end
  end

  context "タイトルが空白のとき" do
    it "記事の作成に失敗する" do
      article = build(:article, title: nil)
      expect(article).not_to be_valid
    end
  end

  context "本文が空白のとき" do
    it "記事の作成に失敗する" do
      article = build(:article, body: nil)
      expect(article).not_to be_valid
    end
  end

  describe "正常に記事が作成されている時" do
    context "タイトルと本文が入力されているとき" do
      let(:article) { build(:article) }

      it "下書き状態の記事が作成できる" do
        expect(article).to be_valid
        expect(article.status).to eq "draft"
      end
    end

    context "status が下書き状態のとき" do
      let(:article) { build(:article, status: "draft") }
      it "記事を下書き状態で作成できる" do
        expect(article).to be_valid
        expect(article.status).to eq "draft"
      end
    end

    context "status が公開状態のとき" do
      let(:article) { build(:article, status: "published") }
      it "記事を公開状態で作成できる" do
        expect(article).to be_valid
        expect(article.status).to eq "published"
      end
    end
  end
end
