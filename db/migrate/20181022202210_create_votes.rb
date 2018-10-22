class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :legislator_id
      t.integer :bill_id
    end
  end
end
