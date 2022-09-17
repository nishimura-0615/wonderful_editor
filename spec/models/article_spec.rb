# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
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
end
