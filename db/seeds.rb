# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts 'Starting extraction for zipped CSV file...'

require 'zip'
file_path = 'db/memory-tech-challenge-data.csv.zip'
zip_file = Zip::File.open(file_path)
entry = zip_file.glob('*.csv').first
csv_text = entry.get_input_stream.read

puts 'CSV has been extracted.'

puts 'starting DB import'
# csv = CSV.parse(csv_text, :headers=>true)
