require 'rails_helper'

RSpec.describe Product do
  context 'validation' do
    it { should validate_presence_of(:price_cents) }
    it { should validate_presence_of(:product_name) }
    it { should validate_presence_of(:external_product_id) }
  end

  context 'when price is updated' do
    let(:vendor) { Vendor.create!(name: "Test") }
    let!(:product) { Product.create(product_name: "tv", price_cents: 50, external_product_id: "ext-id-1", vendor_id: vendor.id) }

    it 'creates a past price record with the old price' do
      expect { product.update_attributes!(price_cents: 100) }.to change{ product.past_price_records.count }.by 1
      expect(product.past_price_records.last.price_cents).to eq 50
      expect(product.past_price_records.last.percentage_change).to eq 1.0
    end
  end
end