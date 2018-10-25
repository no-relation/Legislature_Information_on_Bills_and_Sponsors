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

    def subjects
        subjects_array = []
        self.bills.map do | bill |
            subjects_array.push(bill.subjects)
        end
        subjects_array.flatten.uniq
        # clean_array = subjects_array.flatten.map do |item|
        #     item.gsub(/[\\"+\[+\]]/,"").to_s.split(", ")
        # end
        # clean_array.flatten.uniq
    end

    def self.most_active
        highest_count = 0
        reps_most_active = []
        self.all.each do | rep | 
            if rep.sponsorships.length > highest_count
                reps_most_active = []
                reps_most_active << rep
                highest_count = rep.sponsorships.length
            elsif rep.sponsorships.length == highest_count
                reps_most_active << rep
            end
        end
        {highest_count => reps_most_active}
    end

    def self.least_active
        lowest_count = Float::INFINITY
        reps_least_active = []
        self.all_but_lt_gov.each do | rep | 
            if rep.sponsorships.length < lowest_count
                reps_least_active = []
                reps_least_active << rep
                lowest_count = rep.sponsorships.length
            elsif rep.sponsorships.length == lowest_count
                reps_least_active << rep
            end
        end
        {lowest_count => reps_least_active}
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