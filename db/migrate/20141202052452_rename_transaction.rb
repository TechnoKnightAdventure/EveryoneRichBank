class RenameTransaction < ActiveRecord::Migration
  def self.up
    rename_table :transactions, :transaction_logs
  end
  def self.down
    rename_table :transaction_logs, :transactions
  end
end
