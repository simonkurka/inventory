class ModifyAncestryFromItems < ActiveRecord::Migration
  def change
    change_column :items, :ancestry, :string
  end
end
