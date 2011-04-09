def self.index_for pairs
  @fields ||= {}

  pairs.each do |name, index|
    @fields[index.to_i] = name
  end
end

def self.map_filter &blk
  return nil if not block_given?
  @data || self.data_read
  @data.keep_if &blk
end

def self.map_process &blk
  @data || self.data_read

  if not block_given?
    @data.each do |d|
      if d.class == String
        puts d
      else
        puts d.join("\t")
      end
    end
  end

  @data.each do |d|
    yield d
  end
end

def self.reduce_process &blk
  return if not block_given?
  @data || self.data_read

  @data.each do |d|
    yield d
  end
end

def self.aggregate_sum key, value
  @fields ||= {}

  @fields[0] = key
  @fields[1] = value

  @aggregates ||= {}

  @data || self.data_read

  @data.each do |d|
    k = d[key]
    v = d[value]
    @aggregates[k] ||= 0
    @aggregates[k] += v.is_a?(String)? v.to_i : value
  end
end

def self.aggr_sum key, value
  @aggregates ||= {}
  @aggregates[key] ||= 0
  @aggregates[key] += value.is_a?(String)? value.to_i : value
end

def self.reduce_finish &blk
  @data || self.data_read

  if @aggregates
    data = []
    @aggregates.each do |k,v|
      if @fields[0]
        key = @fields[0]
      else
        key = 'key' 
      end

      if @fields[1]
        value = @fields[1]
      else
        value = 'value' 
      end

      kv = { key => k, value => v }
      data << kv
    end
  else
    data = @data
  end

  if not block_given?
    data.each do |d|
      if d.class == String
        puts d
      else
        puts d.join("\t")
      end
    end
  end

  data.each do |d|
    yield d
  end
end


def self.data_read
  @data ||= []

  STDIN.each_line do |line|
    # if no fields have been defined, process the entire line as one record
    if not @fields or @fields.size < 1
      @data << line.chomp
      next
    end

    fields = line.chomp.split(/\t/)

    h = {}
    @fields.each do |index, name|
      h[name] = fields[index]
    end
    @data << h
  end

  @data
end

def self.read_in line
  @data ||= []
  @data << line.chomp.split(/\t/)
end

def self.emit record
  # add combiner functionality
  puts record.join("\t")
end
