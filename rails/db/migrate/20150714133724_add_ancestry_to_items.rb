class AddAncestryToItems < ActiveRecord::Migration
  def change
    add_column :items, :ancestry, :integer
    add_index :items, :ancestry
  end
end
