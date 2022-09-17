# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_comments_on_article_id  (article_id)
#  index_comments_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Comment, type: :model do
  context "コメントに文字が入力されているとき" do
    let(:comment) { build(:comment) }
    it "コメントが作成される" do
      expect(comment).to be_valid
    end
  end

  context "コメントが空白のとき" do
    it "コメントの作成に失敗する" do
      comment = build(:comment, body: nil)
      expect(comment).not_to be_valid
    end
  end
end
