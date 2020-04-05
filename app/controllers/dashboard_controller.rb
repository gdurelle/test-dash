class DashboardController < ApplicationController
  def index
    @customers_count = Customer.count
    @revenue = Order.sum(:total_amount)
    @avg_rev = @revenue / Order.count
    @countries = Customer.pluck(:country).uniq
  end

  def revenue_per_month
    render json: Order.select("SUM(total_amount) as total_amount,
                              DATE_TRUNC('month', created_at) AS month,
                              DATE_TRUNC('year', created_at) AS year
                              ")
                      .group("year, month").order('year, month')
                      .map{|o| [o.month.strftime('%B %Y'), o.total_amount]}
  end
end
