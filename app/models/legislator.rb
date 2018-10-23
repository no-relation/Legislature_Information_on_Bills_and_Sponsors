class Legislator < ActiveRecord::Base
    has_many :sponsorships
    has_many :bills, through: :sponsorships

    def self.get_ID(query_id)
        result = self.all.find do |lege|
            lege.leg_id == query_id
        end
        if result == nil
            return 0
        else 
            result.id
        end
    end

    def bills_primary
        own_sponsorships = Sponsorship.all.select do |sponsoring|
            sponsoring.legislator_id == self.id && sponsoring.sponsor_type == "primary"
        end 

        own_sponsorships.map do |sponsoring|
            Bill.all.find do |bill|
                bill.id == sponsoring.bill_id
            end
        end
    end

    def bills_cosponsor
        own_sponsorships = Sponsorship.all.select do |sponsoring|
            sponsoring.legislator_id == self.id && sponsoring.sponsor_type == "cosponsor"
        end 

        own_sponsorships.map do |sponsoring|
            Bill.all.find do |bill|
                bill.id == sponsoring.bill_id
            end
        end
    end

end