require 'product_vendor/omega_pricing'
require 'rails_helper'

RSpec.describe ::ProductVendor::OmegaPricing do
  subject { described_class.client }

  describe '#get_product_pricing_records' do
    let(:api_key)    { "abc123key" }
    let(:start_date) { Date.today.prev_month.to_s }
    let(:end_date)   { Date.today.to_s }

    let(:expected_response) do
      {
        productRecords: [
          {
            id: 123456,
            name: "Nice Chair",
            price: "$30.25",
            category: "home-furnishings",
            discontinued: false
          },
          {
            id: 234567,
            name: "Black & White TV",
            price: "$43.77",
            category: "electronics",
            discontinued: true
          },
        ]
      }.to_json
    end

    let(:request_params) do
      {
        "api_key"    =>   api_key,
        "start_date" =>   start_date,
        "end_date"   =>   end_date,
      }
    end

    before do
      ENV["OMEGA_PRICING_API_KEY"] = api_key
      ENV["OMEGA_PRICING_API_BASE_URL"] = "https://omegapricinginc.com"

      stub_request(:get, "https://omegapricinginc.com/pricing/records.json").
        with(query: request_params).
        to_return(status: 200, body: expected_response)
    end

    context 'request is structured correctly' do
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

      it 'receives product records' do
        results = subject.get_product_pricing_records(start_date: start_date, end_date: end_date)

        expect(results).to eq product_records
      end
    end
  end
end