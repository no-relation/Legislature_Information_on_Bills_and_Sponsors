class AddHouseOrSenateToLegislators < ActiveRecord::Migration[5.2]
  def change
    add_column :legislators, :chamber, :string
  end
end
