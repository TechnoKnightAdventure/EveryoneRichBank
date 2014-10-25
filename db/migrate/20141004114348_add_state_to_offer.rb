class AddStateToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :state, :string
  end
end
