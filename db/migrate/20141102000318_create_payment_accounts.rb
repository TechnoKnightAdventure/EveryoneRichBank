class CreatePaymentAccounts < ActiveRecord::Migration
  def change
    create_table :payment_accounts do |t|
      t.belongs_to :user
      t.decimal :current_balance

      t.timestamps
    end
  end
end
