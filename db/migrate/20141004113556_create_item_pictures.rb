class CreateItemPictures < ActiveRecord::Migration
  def change
    create_table :item_pictures do |t|
      t.binary :pic
      t.belongs_to :offer
      t.timestamps
    end
  end
end
