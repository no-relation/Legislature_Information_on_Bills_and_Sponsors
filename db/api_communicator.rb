
def get_bills
#make the web request
  response_string = RestClient.get("https://openstates.org/api/v1/bills/?state=tx&search_window=session&type=bill&apikey=45634606-b8ca-4b1a-a9a3-b06a908c47b5")
  response_hash = JSON.parse(response_string) 
end

def get_legislators
  response_string = RestClient.get("https://openstates.org/api/v1/legislators/?state=tx&apikey=45634606-b8ca-4b1a-a9a3-b06a908c47b5")
  response_hash = JSON.parse(response_string) 
end

def get_individual_bill(bill_id)
  response_string = RestClient.get("https://openstates.org/api/v1/bills/#{bill_id}?apikey=45634606-b8ca-4b1a-a9a3-b06a908c47b5")
  response_hash = JSON.parse(response_string) 
end
