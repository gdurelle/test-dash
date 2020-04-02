class DashboardController < ApplicationController
  def index
    @customers_count = Customer.count
  end
end
