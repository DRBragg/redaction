class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  after_save :update_content
  after_save :update_subject, unless: :redacting?

  redacts :content, with: :text
  redacts :subject

  validates :subject, length: { maximum: 10 }

  private

  def update_content
    update_column(:content, content + " Updated in Callback")
  end

  def update_subject
    update_column(:subject, subject + " Updated in Callback")
  end
end
