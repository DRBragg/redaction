class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  redacts :content, with: :text
  redacts :subject
end
