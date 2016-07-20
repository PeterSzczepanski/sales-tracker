module ProductVendor
  class OmegaPricing

    def self.client
      @client ||= begin
        new(
          # Using fetch to raise loud error if env var is missing
          api_key:  ENV.fetch('OMEGA_PRICING_API_KEY'),
          base_url: ENV.fetch('OMEGA_PRICING_API_BASE_URL'),
        )
      end
    end

    def initialize(api_key:, base_url:)
      @api_key = api_key
      @base_url = base_url
    end

    def get_product_pricing_records(start_date:, end_date:)
      product_url = @base_url + "/pricing/records.json"
      result = get!(
        product_url,
        { start_date: start_date.to_s, end_date: end_date.to_s }
      )
      result['productRecords']
    end

    private

    def get!(url, opts)
      opts.merge!( api_key: @api_key )
      response = RestClient.get(url, params: opts )
      JSON.parse(response)
    end

  end
end