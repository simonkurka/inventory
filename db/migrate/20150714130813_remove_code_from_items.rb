class RemoveCodeFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :code
  end
end
