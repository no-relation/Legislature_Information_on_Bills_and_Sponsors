class AddSubjectsToBills < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :subjects, :string
  end
end
