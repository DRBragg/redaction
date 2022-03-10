class Post < ApplicationRecord
  belongs_to :user, optional: true

  redacts :body, with: :html
  redacts :title, with: :basic_html
end
