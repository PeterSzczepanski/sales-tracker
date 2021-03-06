class Product < ActiveRecord::Base
  before_save :update_past_price_records, if: :price_cents_changed?

  belongs_to :vendor 
  has_many :past_price_records

  monetize :price_cents

  validates :product_name, presence: true
  validates :external_product_id, presence: true, uniqueness: true
  validates :price_cents, presence: true, numericality: { only_integer: true }

  private

  def update_past_price_records
    return if price_cents_was.nil?

    percentage_change = (price_cents - price_cents_was) / price_cents_was.to_f
    past_price_records.create!(price_cents: price_cents_was, percentage_change: percentage_change)
  end
end
