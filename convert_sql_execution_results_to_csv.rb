require 'csv'

file = ARGV[0]
file_name = ARGV[1]
data = File.open(file).read

lines = data.split("\n")
header = lines[0].split("\t").map(&:strip)
data_rows = lines[1..]

CSV.open(file_name, "w", write_headers: true, headers: header) do |csv|
  data_rows.each do |row|
    values = row.split("\t").map(&:strip)
    csv << values
  end
end

puts "CSVファイルへの変換に成功しました！: #{file_name}"
