class Account < ApplicationRecord
  belongs_to :user

  redacts :phone_number, with: :phone
end
