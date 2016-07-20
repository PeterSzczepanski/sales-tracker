class PastPriceRecord < ActiveRecord::Base
  belongs_to :product

  monetize :price_cents
end
