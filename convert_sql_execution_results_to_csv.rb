require 'csv'

# ①dataにsql出力結果を貼り付ける。
data = <<~DATA
+--------+---------------------+---------------------+------------+-----------------------------------------------------------------------------------------------------------+
| id     | created_at          | updated_at          | user_id | key1                                                                                                      |
+--------+---------------------+---------------------+------------+-----------------------------------------------------------------------------------------------------------+
| 1 | 2023-08-31 15:00:29 | 2023-08-31 15:00:29 |        1 | https://rukasan.com |
| 2 | 2023-08-31 15:02:55 | 2023-08-31 15:02:55 |        2 | https://rukasan.com |
DATA

# strip：文字列先頭と末尾の空白文字を全て取り除いた文字列を生成して返します
lines = data.strip.split("\n")
header = lines[1].split("|").map(&:strip)
data_rows = lines[3..]

# ②csv_fileを任意のファイル名に書き換える。
csv_file = "example.csv"
CSV.open(csv_file, "w", write_headers: true, headers: header) do |csv|
  data_rows.each do |row|
    values = row.split("|").map(&:strip)
    
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

puts "CSVファイルへの変換に成功しました！: #{csv_file}"
