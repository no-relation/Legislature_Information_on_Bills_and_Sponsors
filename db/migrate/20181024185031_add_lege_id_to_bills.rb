class AddLegeIdToBills < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :lege_id, :string
  end
end
