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

    def self.all_dems
        
    end

    def self.all_repubs
    end

end