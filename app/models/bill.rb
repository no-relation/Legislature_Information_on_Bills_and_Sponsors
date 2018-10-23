class Bill < ActiveRecord::Base
    has_many :sponsorships
    has_many :legislators, through: :sponsorships

    def self.get_ID(query_id)
        self.all.find do |bill|
            bill.openstates_id == query_id
        end.id
    end
end