class AddSponsorshipType < ActiveRecord::Migration[5.2]
  def change
    add_column :sponsorships, :type, :string
  end
end
