class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    trains << train
  end

  def remove_train(train)
    trains.delete(train)
  end

  def trains_by_type(type)
    trains.select { |t| t.type == type }
  end
end


class Route
  attr_reader :stations

  def initialize(from, to)
    @stations = [from, to]
  end

  def add_station(station)
    stations.insert(-2, station)
  end

  def remove_station(station)
    return if [stations.first, stations.last].include? station
    stations.delete station
  end
end


class Train

  TRAIN_TYPES = [:passenger, :cargo]

  attr_accessor :speed
  attr_reader :number, :length, :type, :route

  def initialize(number, type, length)
    raise 'Не могу создать поезд такого типа!' unless TRAIN_TYPES.include? type
    @number = number
    @type   = type
    @length = length
    @speed  = 0
  end

  def route=(route)
    @route = route
    @station_index = 0
    current_station.add_train(self)
  end

  def stop
    @speed = 0
  end

  def stopped?
    @speed.zero?
  end

  def add_carriage
    @length += 1 if stopped?
  end

  def remove_carriage
    @length -= 1 if stopped? && length > 0
  end

  def forward
    move_to(next_station)
  end

  def backward
    move_to(prev_station)
  end

  def current_station
    route.stations[@station_index] if @station_index
  end

  def next_station
    route.stations[@station_index + 1] if @station_index
  end

  def prev_station
    route.stations[@station_index - 1] if @station_index&.positive?
  end

  private

  def move_to(station)
    raise 'Загрузи маршрут!' unless @route || @station_index
    return unless station

    current_station.remove_train(self)
    station.add_train(self)
    @station_index = route.stations.index(station)
  end
end
