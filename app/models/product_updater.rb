require 'product_vendor/omega_pricing'

module ProductUpdater
  extend self

  def process
    product_records.each do |record|
      existing_product = Product.find_by_external_product_id(record["id"].to_s)
      # Could have an option to perform async/sync
      existing_product ? update_existing_product(record, existing_product) : create_new_product(record)
    end
  end

  private

  def product_records
    @product_records ||= begin
      # Future - Think about rate limiting, pagination, processing async, etc...
      ::ProductVendor::OmegaPricing.client.get_product_pricing_records(
          start_date: Date.today.prev_month,
          end_date:   Date.today,
        )
    end
  end

  def vendor
    # Future - Update product_records to pull in from any given vendor, once the need arises
    @vendor ||= Vendor.find_by_name("Omega Pricing Inc")
  end

  def update_existing_product(record, product)
    if record["name"] == product.product_name
      if record["price"].to_money != product.price
        # Callback automatically handles past price records
        product.update_attributes(price: record["price"].to_money)
      end
    else
      Rails.logger.info "Product Mismatch Found * External Product id #{product.external_product_id} *" \
                        "Expected Name: #{product.product_name} * Actual Name: #{record["name"]}"
    end
  end

  def create_new_product(record)
    return unless !record["discontinued"]
    product = vendor.products.create!(
        product_name:         record["name"],
        price:                record["price"].to_money,
        external_product_id:  record["id"].to_s,
      )
    Rails.logger.info "New Product Added * Vendor: #{vendor.name}, Product id: #{product.id}, " \
                      "External Product id: #{product.external_product_id}"
  end

end
