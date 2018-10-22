
require 'rest-client'
require 'json'
require 'pry'

def get_bills_test
#make the web request
    puts "Enter Query:"
    query = gets.chomp
  response_string = RestClient.get("https://openstates.org/api/v1/bills/?state=tx&q=#{query}&apikey=45634606-b8ca-4b1a-a9a3-b06a908c47b5")
  response_hash = JSON.parse(response_string) 
end

binding.pry
0