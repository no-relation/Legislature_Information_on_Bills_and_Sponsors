class Bill < ActiveRecord::Base
    has_many :sponsorships
    has_many :legislators, through: :sponsorships
    
    #helper method
    def self.get_ID(query_id)
        self.all.find do |bill|
            bill.openstates_id == query_id
        end.id    
    end    
    
    #helper method
    def get_bill_id
        self.id
    end

    #helper method
    def sponsor_count_by_party(party) #will take in "Democratic" or "Republican"
        id = get_bill_id
        Bill.find(id).sponsorships.count do |sponsor|
            if sponsor["legislator_id"] != 0
                Legislator.find(sponsor["legislator_id"]).party == party
            end
        end
    end

    #helper method
    def clean_array_of_leg_id_0(array)
        array.each_with_index do |sponsor, i|
            if sponsor["legislator_id"] == 0
                array.delete_at(i)
            end
        end
    end

    #helper method
    def turn_array_of_legislators_to_full_names(array)
        cleaned_array = clean_array_of_leg_id_0(array)
        array_of_names = cleaned_array.map do |sponsor|
            Legislator.find(sponsor["legislator_id"]).full_name
        end
    end

    #helper method
    def turn_sponsorships_array_into_leg_array(array)
        cleaned_array = clean_array_of_leg_id_0(array)
        array_of_leg = cleaned_array.map do |sponsor|
            Legislator.find(sponsor["legislator_id"])
        end
    end
    

    def self.most_sponsors
        # output {num of sponsors => [the bill instances]}
        # use #all_sponsors or #all_sponsors_by_party to return the sponsors of a specific bill
        most_sponsors_count = 0
        most_sponsors_bill = []
        Bill.all.each do |bill|
            the_count = bill.sponsorships.count
            if the_count > most_sponsors_count
                most_sponsors_count = the_count
                most_sponsors_bill = []
                most_sponsors_bill << bill
            elsif the_count == most_sponsors_count
                most_sponsors_bill << bill
            end
        end
        #puts "There is/are #{most_sponsors_bill.length} bill(s) with the most (#{most_sponsors_count}) sponsors."
        return {most_sponsors_count => most_sponsors_bill}
    end


    def self.least_sponsors
        least_sponsors_count = 500
        least_sponsors_bill = []
        Bill.all.each do |bill|
            the_count = bill.sponsorships.count
            if the_count < least_sponsors_count
                least_sponsors_count = the_count
                least_sponsors_bill = []
                least_sponsors_bill << bill
            elsif the_count == least_sponsors_count
                least_sponsors_bill << bill
            end
        end
        #puts "There is/are #{least_sponsors_bill.length} bill(s) with the least (#{least_sponsors_count}) sponsors."
        return {least_sponsors_count => least_sponsors_bill}
    end  


    def self.most_dem
        # looks through all bills and counts how many dem sponsors per bill, returns the bill with largest count
        most_dem_count = 0
        most_dem_bill = []
        Bill.all.each do |bill|
            the_count = bill.sponsorships.count do |sponsor|
                if sponsor["legislator_id"] != 0
                    Legislator.find(sponsor["legislator_id"]).party == "Democratic"
                end
            end 
            if the_count > most_dem_count
                most_dem_count = the_count
                most_dem_bill = []
                most_dem_bill << bill
            elsif the_count == most_dem_count
                most_dem_bill << bill
            end    
        end    
        titles = most_dem_bill.map {|bill| bill.title}
        #puts "There is/are #{titles.length} bill(s) with the most (#{most_dem_count}) dem sponsors: #{titles}."
        return most_dem_bill
    end


    def self.most_repub
        # looks through all bills and counts how many repub sponsors per bill, returns the bill with largest count
        most_repub_count = 0
        most_repub_bill = []
        Bill.all.each do |bill|
            the_count = bill.sponsorships.count do |sponsor|
                if sponsor["legislator_id"] != 0
                    Legislator.find(sponsor["legislator_id"]).party == "Republican"
                end
            end 
            if the_count > most_repub_count
                most_repub_count = the_count
                most_repub_bill = []
                most_repub_bill << bill
            elsif the_count == most_repub_count
                most_repub_bill << bill
            end    
        end    
        titles = most_repub_bill.map {|bill| bill.title}
        #puts "There is/are #{titles.length} bill(s) with the most (#{most_repub_count}) repub sponsors: #{titles}."
        return most_repub_bill
    end
     

    def bipartisan_count
        dem_count = sponsor_count_by_party("Democratic")
        repub_count = sponsor_count_by_party("Republican")
        #puts "This bill had #{dem_count} dem sponsors and #{repub_count} repub sponsors."
        return {"Democratic" => dem_count, "Republican" => repub_count}
    end


    def self.most_relative_dem
        most_dem_ratio = 0 #1 is highest
        most_dem_bill = []
        return_hash = {}

        Bill.all.each do |bill|
            bipartisan_hash = bill.bipartisan_count
            if bipartisan_hash["Democratic"] > 1
                ratio_hash = {bipartisan_hash["Democratic"] => (bipartisan_hash["Republican"] + bipartisan_hash["Democratic"])}
                ratio_num = bipartisan_hash["Democratic"] / ratio_hash[bipartisan_hash["Democratic"]]
                if ratio_num > most_dem_ratio
                    most_dem_ratio = ratio_num
                    most_dem_bill = []
                    most_dem_bill << bill
                    return_hash = ratio_hash
                elsif ratio_num == most_dem_ratio
                    most_dem_bill << bill
                end
            end
        end
        # puts most_dem_ratio
        # puts most_dem_bill
        # puts most_dem_bill.length
        # puts return_hash
        return {return_hash => most_dem_bill}
    end


    def self.most_relative_repub
        most_repub_ratio = 0 #1 is highest
        most_repub_bill = []
        return_hash = {}

        Bill.all.each do |bill|
            bipartisan_hash = bill.bipartisan_count
            if bipartisan_hash["Republican"] > 1
                ratio_hash = {bipartisan_hash["Republican"] => (bipartisan_hash["Democratic"] + bipartisan_hash["Republican"])}
                ratio_num = bipartisan_hash["Republican"] / ratio_hash[bipartisan_hash["Republican"]]
                if ratio_num > most_repub_ratio
                    most_repub_ratio = ratio_num
                    most_repub_bill = []
                    most_repub_bill << bill
                    return_hash = ratio_hash
                elsif ratio_num == most_repub_ratio
                    most_repub_bill << bill
                end
            end
        end
        return {return_hash => most_repub_bill}
    end


    def self.most_bipartisan
        #iterates thru each bill to find bipartisan_count, creates a ratio, sorts, returns middle
        an_array = []

        Bill.all.each do |bill|
            an_array << {bill => bill.bipartisan_count}
        end

        an_array.sort
    end


    def primary_sponsors
        #lists each primary sponsor of a bill
        array = self.sponsorships.select do |sponsor|
            sponsor.sponsor_type == "primary"
        end
        #array_of_names = turn_array_of_legislators_to_full_names(array)
        #puts "There are #{array_of_names.count} primary sponsors: #{array_of_names}"
        array_of_leg = turn_sponsorships_array_into_leg_array(array)
        return array_of_leg
    end


    def cosponsors
        #lists each cosponsor of a bill
        array = self.sponsorships.select do |sponsor|
            sponsor.sponsor_type == "cosponsor"
        end
        #array_of_names = turn_array_of_legislators_to_full_names(array)
        #puts "There are #{array_of_names.count} cosponsors: #{array_of_names}"
        array_of_leg = turn_sponsorships_array_into_leg_array(array)
        return array_of_leg
    end


    def all_sponsors
        #lists primary and cosponsors of a bill
        array = self.sponsorships.select do |sponsor|
            sponsor.sponsor_type == "primary" || sponsor.sponsor_type == "cosponsor"
        end
        #array_of_names = turn_array_of_legislators_to_full_names(array)
        #puts "There are #{array_of_names.count} sponsors: #{array_of_names}"
        array_of_leg = turn_sponsorships_array_into_leg_array(array)
        return array_of_leg
    end


    def all_sponsors_by_party
        #returns a hash {dem: [instancs], repub: [instances]}
        array_of_sponsors = self.all_sponsors
        cleaned_array = clean_array_of_leg_id_0(array_of_sponsors)
        dem_array = []
        repub_array = []
        cleaned_array.each do |sponsor|
            if Legislator.find(sponsor["legislator_id"]).party == "Democratic"
                dem_array << Legislator.find(sponsor["legislator_id"])
            elsif Legislator.find(sponsor["legislator_id"]).party == "Republican"
                repub_array << Legislator.find(sponsor["legislator_id"])
            end
        end
        puts "#{dem_array.count} dems and #{repub_array.count} repubs"
        return {"Democratic" => dem_array, "Republican" => repub_array}
    end


    def subjects
        #output array with subjects of a bill
        clean_array = self["subjects"].gsub(/[\\"+\[+\]]/,"").to_s.split(", ")
        return clean_array.flatten.uniq
    end


    def self.subjects
        subjects_array = []
        Bill.all.map do | bill |
            subjects_array.push(bill.subjects)
        end
        clean_array = subjects_array.map do |item|
            item.gsub(/[\\"+\[+\]]/,"").to_s.split(", ")
        end
        return clean_array.flatten.uniq
    end

end