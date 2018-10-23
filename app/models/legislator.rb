class Legislator < ActiveRecord::Base
    has_many :sponsorships
    has_many :bills, through: :sponsorships

    def self.all_but_lt_gov
        self.all[1..self.all.length]
    end

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

    def bills
        self.bills_primary.concat(self.bills_cosponsor)
    end

    def self.most_active
        highest_count = 0
        rep_most_active = nil
        self.all.each do | rep | 
            if rep.bills.length > highest_count
                rep_most_active = rep
                highest_count = rep.bills.length
            end
        end
        rep_most_active
    end

    def self.least_active
        lowest_count = Float::INFINITY
        rep_least_active = nil
        self.all_but_lt_gov.each do | rep | 
            if rep.bills.length < lowest_count
                rep_least_active = rep
                lowest_count = rep.bills.length
            end
        end
        rep_least_active
    end

    def self.dems
        self.all.select do | lege |
            lege.party == "Democratic"
        end
    end

    def self.reps 
        self.all.select do | lege |
            lege.party == "Republican"
        end
    end

end