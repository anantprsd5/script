# frozen_string_literal: true

require "json"
require 'csv'

# @param file_path [String]
def convert_json_to_csv(file_path)
  xa = []
  ya = []
  za = []
  output = []
  file = File.open(file_path)
  json = JSON.parse(file)
  json.each do |_, data|
    anomaly = data["anomaly"]
    normal = data["normal"]
    anomaly.each do |_, value|
      val_array = value.gsub(/\s+/, "").split('=')
      xa << val_array[1].chop
      ya << val_array[2].chop
      za << val_array[3]
      output << 1
    end

    normal.each do |key, value|
      val_array = value.gsub(/\s+/, "").split('=')
      xa << val_array[1].chop
      ya << val_array[2].chop
      za << val_array[3]
      output << 0
    end
  end
  zipped = xa.zip(ya, za, output)
  CSV.open("converted.csv", "w") do |csv|
    csv << %w[x y z val]
    zipped.each do |vals|
      csv << [vals[0], vals[1], vals[2], vals[3]]
    end
  end
end

