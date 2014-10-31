class DeleteOffersAndItemPictures < ActiveRecord::Migration
  def change
    drop_table :offers
    drop_table :item_pictures
  end
end
