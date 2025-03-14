require "csv"

file = ARGV[0]
file_name = ARGV[1]
sjis_flag = ARGV[2] || false
data = File.open(file).read

def encode_to_sjis(s, sjis_flag)
  if sjis_flag
    s&.encode(Encoding::SHIFT_JIS, invalid: :replace, undef: :replace)
  else
    s
  end
end

lines = data.split("\n")
header = lines[0].split("\t").map(&:strip)
header.map! { encode_to_sjis(_1, sjis_flag) }
data_rows = lines[1..]

CSV.open(file_name, "w", write_headers: true, headers: header) do |csv|
  data_rows.each do |row|
    values = row.split("\t").map do |value|
      encode_to_sjis(value.strip, sjis_flag)
    end
    csv << values
  end
end

puts "Successfully converted to CSV file. #{file_name}"