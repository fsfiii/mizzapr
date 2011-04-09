require 'mizzapr'

index_for phone: 0
index_for key:   3
index_for name:  2
index_for age:   5

map_filter do |rec|
  rec[:age].to_i < 30
end

map_process do |rec|
  emit rec[:key], rec[:name], rec[:phone], rec[:age].to_i - 1
end
