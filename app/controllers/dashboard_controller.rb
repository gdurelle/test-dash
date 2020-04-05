class DashboardController < ApplicationController
  def index
    @customers_count = Customer.count
    @revenue = Order.sum(:total_amount)
    @avg_rev = @revenue / Order.count
    @countries = Customer.pluck(:country).uniq
  end
end
