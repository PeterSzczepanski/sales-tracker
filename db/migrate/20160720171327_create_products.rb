class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      # leaving "product_name", as was on the spec. Recommending this to be just "name".
      t.string :product_name, null: false, unique: true
      t.integer :price_cents, null: false
      # string since future vendors might have alphanumberic values
      t.string :external_product_id, index: true, unique: true, null: false
      t.integer :vendor_id, null: false

      t.timestamps null: false
    end
  end
end
