require 'csv'

file = ARGV[0]
file_name = ARGV[1]
data = File.open(file).read

# ①dataにsql出力結果を貼り付ける。
# data = <<~DATA
# DATA

# strip：文字列先頭と末尾の空白文字を全て取り除いた文字列を生成して返します
lines = data.split("\n")
header = lines[0].split(" ").map(&:strip)
data_rows = lines[1..]

CSV.open(file_name, "w", write_headers: true, headers: header) do |csv|
  data_rows.each do |row|
    values = row.split(" ").map(&:strip)
    
    # 16進数エンコードされた文字列をデコードして正しい値に変換
    decoded_values = values.map.with_index do |value, index|
      if value.start_with?("0x") && index >= 2
        hex_string = value.delete_prefix("0x").delete(' ')
        byte_data = [hex_string].pack('H*')
        decoded_value = byte_data.force_encoding('UTF-8')
        decoded_value
      else
        value
      end
    end
    
    csv << decoded_values
  end
end

puts "CSVファイルへの変換に成功しました！: #{file_name}"
