require 'net/http'

url = 'http://www.google.com.bd'
res = Net::HTTP.get_response(URI.parse(url.to_s))
puts res.body