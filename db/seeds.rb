require_relative 'api_communicator'

fake_dude = Legislator.create(full_name: "Fakey McFaker", leg_id: "FAKEID", party: "Democrat")
fake_bill = Bill.create(title: "Bill to make things better", openstates_id: "TXB00000000")
fake_sponsorship = Sponsorship.create(bill: fake_bill, legislator: fake_dude)

# get_bills: title, openstates_id
get_bills.each do |bill|
    Bill.create(title: bill["title"], openstates_id: bill["id"])
end

# get_legislators: full_name, leg_id, party
get_legislators.each do |lege|
    Legislator.create(full_name: lege['full_name'], leg_id: lege['id'], party: lege['party'])
end

# get_individual_bill(bill_id): sponsorships: bill_id, legislator_id, type
Bill.all.each do |bill|
    get_individual_bill(bill[openstates_id]).each do |bill_stats|
        bill_stats["sponsors"].each do |sponsor|
            Sponsorship.create(openstates_id: bill_stats["id"], leg_id: sponsor["leg_id"], type: sponsor["type"])
        end
    end
end
