# Hashing a secret with bcrypt, the way has_secure_password does it.
#
#   bin/rails runner scripts/encryption.rb

secret = "puppies"

# The same secret, hashed twice. Each hash carries its own random salt, so the two
# strings differ, and neither can be turned back into "puppies".
first = BCrypt::Password.create(secret)
second = BCrypt::Password.create(secret)
puts first
puts second

# Checking a guess: bcrypt reads the salt out of the stored hash, hashes the guess
# with it, and compares. The stored hash never has to be decrypted.
puts BCrypt::Password.new(first) == "puppies"
puts BCrypt::Password.new(second) == "puppies"
puts BCrypt::Password.new(first) == "kittens"
