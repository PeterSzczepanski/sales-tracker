class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :product_name
      t.integer :price_cents, null: false
      # string since future vendors might have alphanumberic values
      t.string :external_product_id, index: true, null: false
      t.integer :vendor_id, null: false

      t.timestamps null: false
    end
  end
end
