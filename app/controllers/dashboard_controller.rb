class DashboardController < ApplicationController
  def index
    if params[:country]
      @customers_count = Customer.where(country: params[:country]).count
      @revenue = Order.where(country: params[:country]).sum(:total_amount)
      @avg_rev = @revenue / Order.where(country: params[:country]).count
      @countries = Customer.pluck(:country).uniq
    else
      @customers_count = Customer.count
      @revenue = Order.sum(:total_amount)
      @avg_rev = @revenue / Order.count
      @countries = Customer.pluck(:country).uniq
    end
  end

  def revenue_per_month
    if params[:country]
      revpm = Order.select("SUM(total_amount) as total_amount,
                              DATE_TRUNC('month', created_at) AS month,
                              DATE_TRUNC('year', created_at) AS year
                              ")
                      .where(country: params[:country])
                      .group("year, month").order('year, month')
                      .map{|o| [o.month.strftime('%B %Y'), o.total_amount]}
    else
      revpm = Order.select("SUM(total_amount) as total_amount,
                              DATE_TRUNC('month', created_at) AS month,
                              DATE_TRUNC('year', created_at) AS year
                              ")
                      .group("year, month").order('year, month')
                      .map{|o| [o.month.strftime('%B %Y'), o.total_amount]}
    end
    render json: revpm
  end
end
