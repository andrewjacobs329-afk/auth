# Your Week 4 Bitcoin file, in this app. Run it from the top folder:
#   bin/rails runner scripts/bitcoin.rb
# Today it becomes a page: the Ruby moves into a controller action, and the
# puts lines become a view.

# connect to the Blockchain.com Exchange Rates API
require "net/http"
require "json"
url = "https://blockchain.info/ticker"
uri = URI(url)
response = Net::HTTP.get(uri)
bitcoin_data = JSON.parse(response)

bitcoin = 1.5
usd_rate = bitcoin_data["USD"]["last"]
usd_value = usd_rate * bitcoin

puts "You have #{bitcoin} Bitcoin."
puts "1 Bitcoin is worth $#{usd_rate}."
puts "Your Bitcoin is worth $#{usd_value}."
