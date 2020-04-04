class Order < ApplicationRecord
  belongs_to :customer
  monetize :total_amount_cents
end
