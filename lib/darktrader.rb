require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'rubocop'

doc = Nokogiri::HTML(URI.open("https://coinmarketcap.com/all/views/all/"))

# Using xpath and css selector to select the class of the symbol 
symbol = doc.xpath('.//tbody').css('.cmc-table__cell--sort-by__symbol')
symbol_text = symbol.map{|abc| abc.text}

# Using xpath and css selector to select the class of the price
price = doc.xpath('.//tbody').css('.cmc-table__cell--sort-by__price')
price_text = price.map{|prc| prc.text}

# method to convert 2 arrays into hash
def perform(key, value)
  result = []
  key.each_with_index do |k, v|
    result << {k => (value)[v]} #On push dans l'array une portion de hash composer de: key = symbol_text et value = price_text[v] 
  end
  puts result
  return result
end

perform(symbol_text, price_text)