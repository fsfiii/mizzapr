require 'mizzapr'

map_process do |rec|
  rec.split.each { |word| emit word.downcase, 1 }
end
