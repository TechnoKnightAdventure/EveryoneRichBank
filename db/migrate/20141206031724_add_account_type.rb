class AddAccountType < ActiveRecord::Migration
  def change
    add_column :payment_accounts, :account_type, :string, :default => "Checking"
  end
end
