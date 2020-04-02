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
# ####################################
# ####################################

puts 'Reading CSV file...'
customers_objects = []
customers_ids = Set.new
orders_objects = []
orders_ids = Set.new
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
  end
  puts "Customers in CSV: #{customers_ids.size}"
  puts "Orders in CSV: #{orders_ids.size}"
  puts '---'
  # ####################################
  # ######### IMPORT in bulk ###########
  # ####################################
  puts 'Starting DB import'
  import_customers = Customer.bulk_import(customers_objects,
                                          on_duplicate_key_ignore: true,
                                          conflict_target: :import_id,
                                          batch_size: customers_objects.size/2,
                                          returning: :import_id
                                          )
  puts "Customers imported: #{import_customers.results.size}"

  import_orders = Order.bulk_import(orders_objects,
                                          on_duplicate_key_ignore: true,
                                          conflict_target: :import_id,
                                          batch_size: orders_objects.size/2,
                                          returning: :import_id
                                          )
  puts "Orders imported: #{import_orders.results.size}"

ensure
  File.delete(csv_file_path)
  puts "CSV file has been delete after treatment."
end
