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
customers = Set.new

begin
  CSV.foreach(csv_file_path, headers: true) do |row|
    customers << Customer.new(import_id: row['customer_id'],
                              country: row['country'])
  end
  puts "Customers in CSV: #{customers.size}"
  import_customers = Customer.bulk_import(customers.to_a,
                                          batch_size: customers.size/2,
                                          returning: :import_id
                                          )
  puts "Customers imported: #{import_customers.results.size}"
ensure
  File.delete(csv_file_path)
  puts "CSV file has been delete after treatment."
end
