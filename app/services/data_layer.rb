class DataLayer
  def self.add_data(data)
    Thread.current[:data_layer] ||= []
    Thread.current[:data_layer] << data
  end
end
