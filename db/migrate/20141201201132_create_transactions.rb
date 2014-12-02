class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.belongs_to :payment_account

      t.integer  :actor_id
      t.string   :description
      t.string   :trans_type
      t.decimal  :amount

      t.timestamps
    end
  end
end
