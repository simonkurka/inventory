class ModifyItemSetCodeUnique < ActiveRecord::Migration
  def change
    add_index :items, :code, unique: true
  end
end
