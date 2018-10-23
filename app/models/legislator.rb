class Legislator < ActiveRecord::Base
    has_many :sponsorships
    has_many :bills, through: :sponsorships

    def self.get_ID(query_id)
        self.all.find do |lege|
            lege.leg_id == query_id
        end.id
    end
end