class AddSponsorshipType < ActiveRecord::Migration[5.2]
  def change
    add_column :sponsorships, :sponsor_type, :string
  end
end
