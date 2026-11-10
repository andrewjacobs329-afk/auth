class User < ApplicationRecord
  # Gives the model a password= method that hashes what it is given into the
  # password_digest column, and an authenticate(guess) method that checks a guess
  # against that hash. The plain password column is no longer written.
  has_secure_password
end
