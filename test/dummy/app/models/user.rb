class User < ApplicationRecord
  redacts :first_name, with: :name
  redacts :email, with: :email
end
