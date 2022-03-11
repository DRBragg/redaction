class Post < ApplicationRecord
  belongs_to :user

  redacts :body, with: :html
  redacts :title, with: :basic_html
end
