class PastPriceRecord < ActiveRecord::Base
  belongs_to :product

  monetize :price_cents

  validates :price_cents, presence: true
  validates :percentage_change, presence: true
end
