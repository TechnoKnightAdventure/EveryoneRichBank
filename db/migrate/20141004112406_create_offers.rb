class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.integer :userID
      t.string :fullname
      t.text :message
      t.binary :userPic
      t.timestamps :creationDate
      t.timestamps
    end
  end
end
