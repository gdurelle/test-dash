class OrderItem < ApplicationRecord
  belongs_to :order
  monetize :unit_price_cents
end
