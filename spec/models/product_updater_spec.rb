require 'rails_helper'

RSpec.describe ::ProductUpdater do
  subject { described_class }

  describe '#process' do
    let!(:vendor) { Vendor.create!(name: "Omega Pricing Inc") }
    let(:product_records) do
      [{"id"=>123456,
        "name"=>"Nice Chair",
        "price"=>"$30.25",
        "category"=>"home-furnishings",
        "discontinued"=>false},
       {"id"=>234567,
        "name"=>"Black & White TV",
        "price"=>"$43.77",
        "category"=>"electronics",
        "discontinued"=>true}]
    end

    before do
      allow(::ProductVendor::OmegaPricing.client).to receive(:get_product_pricing_records).
        with( start_date: Date.today.prev_month, end_date: Date.today ).
        and_return(product_records)
    end

    context 'When there are no existing products in the database' do
      it 'creates new products for items that are NOT discontinued' do
        expect(Rails.logger).to receive(:info).with(/New Product Added/)
        expect(Product.count).to be 0
        expect { subject.process }.to change{ vendor.products.count }.by 1
        expect(vendor.products.first.product_name).to eq "Nice Chair"
      end
    end

    context 'When there are existing products in the database' do
      let!(:product_1) { vendor.products.create!( product_name: "Nice Chair", price: "$10.00".to_money, external_product_id: "123456" ) } 
      let!(:product_2) { vendor.products.create!( product_name: "Black & White TV", price: "$20.00".to_money, external_product_id: "234567" ) } 

      it 'updates pricing for all products, even if the product is discontinued' do
        expect(Product.count).to be 2
        expect(PastPriceRecord.count).to be 0

        subject.process

        expect(Product.count).to be 2
        expect(PastPriceRecord.count).to be 2

        expect(product_1.reload.price_cents).to eq 3025
        expect(product_2.reload.price_cents).to eq 4377
        expect(product_1.past_price_records.last.price_cents).to eq 1000
        expect(product_2.past_price_records.last.price_cents).to eq 2000
      end
    end

    context 'When there is a name mismatch on an existing product' do
      let!(:product_1) { vendor.products.create!( product_name: "Nice Car", price: "$10.00".to_money, external_product_id: "123456" ) } 

      it 'does NOT update the price' do
        expect(Rails.logger).to receive(:info).with(/Product Mismatch Found/)
        expect { subject.process }.not_to change{ product_1.reload.price }
      end
    end
  end
end