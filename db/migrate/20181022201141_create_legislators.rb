class CreateLegislators < ActiveRecord::Migration[5.2]
  def change
    create_table :legislators do |t|
      t.string :full_name
      t.string :leg_id
      t.string :district
    end
  end
end
