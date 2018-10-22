class Sponsorship < ActiveRecord::Base
    belongs_to :bill
    belongs_to :legislator
end