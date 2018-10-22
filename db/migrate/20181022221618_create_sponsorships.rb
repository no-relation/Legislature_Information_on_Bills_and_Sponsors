class CreateSponsorships < ActiveRecord::Migration[5.2]
  def change
    create_table :sponsorships do |t|
      t.belongs_to :bill
      t.belongs_to :legislator
    end
  end
end
