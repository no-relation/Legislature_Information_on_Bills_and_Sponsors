class AddPartyToLegislators < ActiveRecord::Migration[5.2]
  def change
    add_column :legislators, :party, :string
  end
end
