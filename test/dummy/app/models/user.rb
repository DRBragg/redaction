class User < ApplicationRecord
  attr_encrypted :ssn, key: "This is a key that is 256 bits!!"
  lockbox_encrypts :phone

  redacts :first_name, with: :name
  redacts :middle_name, with: ->(record) { "#{record.model_name.human} #{record.id}" }
  redacts :suffix, with: :missing
  redacts :username, with: Custom
  redacts :email, with: :email
  redacts :ssn, :phone
end
