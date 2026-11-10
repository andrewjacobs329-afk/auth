class BitcoinsController < ApplicationController
  def index
    # connect to the Blockchain.com Exchange Rates API (the Week 4 code)
    require "net/http"
    require "json"
    response = Net::HTTP.get(URI("https://blockchain.info/ticker"))
    bitcoin_data = JSON.parse(response)

    # the amount comes from the address: /bitcoins?amount=2.6
    # (it was @bitcoin = 1.5 first; params values are strings, so to_f)
    @bitcoin = params["amount"].to_f
    @usd_rate = bitcoin_data["USD"]["last"]
    @usd_value = @usd_rate * @bitcoin

    render({ :template => "bitcoins/index" })
  end
end
