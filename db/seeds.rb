require 'zip'
require 'csv'

# ####################################
# ######### ZIP extraction ###########
# ####################################
puts 'Starting extraction for zipped CSV file...'
file_path = 'db/memory-tech-challenge-data.csv.zip'
zip_file = Zip::File.open(file_path)
entry = zip_file.glob('*.csv').first
# csv_text = entry.get_input_stream.read
csv_file_name = entry.name
csv_file_path = File.join('db', csv_file_name)
entry.extract(csv_file_path)
puts "File #{csv_file_name} has been extracted."
puts "---"
# ####################################
# ####################################

puts 'Reading CSV file...'
customers_objects = []
customers_ids = Set.new
orders_objects = []
orders_ids = Set.new
order_items_objects = []
order_total = 0.0
begin
  # ####################################
  # ########## CSV read  ###############
  # ####################################
  CSV.foreach(csv_file_path, headers: true) do |row|
    unless customers_ids.include?(row['customer_id'])
      customers_objects << Customer.new(import_id: row['customer_id'],
                                country: row['country'])
      customers_ids << row['customer_id']
    end

    unless orders_ids.include?(row['order_id'])
      orders_objects << Order.new(import_id: row['order_id'],
                          country: row['country'],
                          customer: customers_objects.last,
                          created_at: row['date'].to_date
                          )
      orders_ids << row['order_id']
    end

    # calculus order_total
    if row['order_id'].to_i == orders_objects.last.import_id && !order_items_objects.empty?
      order_total += order_items_objects.last.quantity * order_items_objects.last.unit_price
    else
      orders_objects.last.total_amount = order_total
      order_total = 0.0
    end
    # puts "#{row['order_id']}--#{orders_objects.last.total_amount} with #{order_total}"

    order_items_objects << OrderItem.new({
                              order: orders_objects.last,
                              product_code: row['product_code'],
                              product_description: row['product_description'],
                              quantity: row['quantity'],
                              unit_price: row['unit_price']
                            }
                        )
    if !order_items_objects.last.valid?
      raise "Invalid OrderItem: #{order_items_objects.last.errors.to_json}"
    end
  end
  puts "Customers in CSV: #{customers_ids.size}"
  puts "Orders in CSV: #{orders_ids.size}"
  puts "OrderItems in CSV: #{order_items_objects.size}"
  puts '---'
  # ####################################
  # ######### IMPORT in bulk ###########
  # ####################################
  puts("Cleanup DB")
  OrderItem.delete_all
  Order.delete_all
  Customer.delete_all

  puts 'DB import...'
  import_customers = Customer.bulk_import(customers_objects, returning: :import_id)
  puts "Customers imported: #{import_customers.results.size}"

  import_orders = Order.bulk_import(orders_objects, returning: :import_id)
  puts "Orders imported: #{import_orders.results.size}"

  import_order_items = OrderItem.bulk_import(order_items_objects, returning: :id)
  puts "OrderItems imported: #{import_order_items.results.size}"

ensure
  File.delete(csv_file_path)
  puts "CSV file has been delete after treatment."
end
