require 'rails_helper'

RSpec.describe PastPriceRecord do
  it { should validate_presence_of(:price_cents) }
  it { should validate_presence_of(:percentage_change) }
end