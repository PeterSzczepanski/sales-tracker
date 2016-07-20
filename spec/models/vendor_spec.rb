require 'rails_helper'

RSpec.describe Vendor do
  it { should validate_presence_of(:name) }
end