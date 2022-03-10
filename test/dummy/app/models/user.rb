class User < ApplicationRecord
  redacts :email, with: :email
end
