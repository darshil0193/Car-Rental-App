class AddManagementToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :users, :superadmin, :boolean, default: false
  end
end
