require_relative 'mizzapr'

aggregate_sum :word, :count

reduce_finish do |rec|
  emit [rec[:word], rec[:count]]
end
