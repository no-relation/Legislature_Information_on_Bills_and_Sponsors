class Bill < ActiveRecord::Base
    has_many :sponsorships
    has_many :legislators, through: :sponsorships

    def self.get_ID(query_id)
        self.all.find do |bill|
            bill.openstates_id == query_id
        end.id
    end

    def self.most_dem
        # looks through all bills and counts how many dem sponsors per bill, returns the bill with largest count

        most_dem_count = 0
        most_dem_bill = []
        i = 1
        while i <= Bill.all.length
            the_count = Bill.find(i).sponsorships.count do |sponsor|
                if sponsor["legislator_id"] != 0
                    Legislator.find(sponsor["legislator_id"]).party == "Democratic"
                end
            end
            if the_count > most_dem_count
                most_dem_count = the_count
                most_dem_bil = []
                most_dem_bill << Bill.find(i)
            elsif the_count == most_dem_count
                most_dem_bill << Bill.find(i)
            end
            i += 1
        end
        titles = most_dem_bill.map {|bill| bill.title}
        puts "There is/are #{titles.length} bill(s) with the most (#{most_dem_count}) dem sponsors: #{titles}."
        return most_dem_bill
    end

    def self.most_repub
        #same as above with repub
        most_repub_count = 0
        most_repub_bill = []
        i = 1
        while i <= Bill.all.length
            the_count = Bill.find(i).sponsorships.count do |sponsor|
                if sponsor["legislator_id"] != 0
                    Legislator.find(sponsor["legislator_id"]).party == "Republican"
                end
            end
            if the_count > most_repub_count
                most_repub_count = the_count
                most_repub_bill = []
                most_repub_bill << Bill.find(i)
            elsif the_count == most_repub_count
                most_repub_bill << Bill.find(i)
            end
            i += 1
        end
        titles = most_repub_bill.map {|bill| bill.title}
        puts "There is/are #{titles.length} bill(s) with the most (#{most_repub_count}) repub sponsors: #{titles}."
        return most_repub_bill
    end

    def bipartisan_count
        #counts dems and counts repubs and gives a count of each
        #interpolate the difference "5 more dems sponsored this"
    end

    def self.most_bipartisan
        #iterates thru each bill to find bipartisan_count, creates a ratio, sorts, returns middle
    end

    def primary_sponsors
        #lists each primary sponsor of a bill
    end

    def all_sponsors
        #lists primary and cosponsors of a bill
    end
    
end