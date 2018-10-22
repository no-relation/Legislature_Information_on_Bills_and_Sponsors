require_relative 'api_communicator'

fake_dude = Legislator.create(full_name: "Fakey McFaker", leg_id: "FAKEID", party: "Democrat")
fake_bill = Bill.create(title: "Bill to make things better", openstates_id: "TXB00000000")
fake_sponsorship = Sponsorship.create(bill: fake_bill, legislator: fake_dude)