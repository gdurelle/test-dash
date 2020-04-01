require 'zip'
require 'csv'

puts 'Starting extraction for zipped CSV file...'
file_path = 'db/memory-tech-challenge-data.csv.zip'
zip_file = Zip::File.open(file_path)
entry = zip_file.glob('*.csv').first
# csv_text = entry.get_input_stream.read
csv_file_name = entry.name
csv_file_path = File.join('db', csv_file_name)
entry.extract(csv_file_path)
puts "File #{csv_file_name} has been extracted."

puts 'starting DB import'

begin
  customers = Set.new
  CSV.foreach(csv_file_path, headers: true) do |row|
    customers << {import_id: row['customer_id'], country: row['country'] }
  end
  puts "Customers in CSV: #{customers.size}"
  import_customers = Customer.import(customers)
  puts "Customers imported: #{import_customers.num_inserts}"
ensure
  File.delete(csv_file_path)
  puts "CSV file has been delete after treatment."
end
