class User < ApplicationRecord
  attr_encrypted :ssn, key: "This is a key that is 256 bits!!"
  lockbox_encrypts :phone

  redacts :first_name, with: :name
  redacts :email, with: :email
  redacts :ssn, :phone
end
