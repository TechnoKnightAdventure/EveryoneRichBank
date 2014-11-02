class AddNameToPaymentAccounts < ActiveRecord::Migration
  def change
    add_column :payment_accounts, :name, :string
  end
end
