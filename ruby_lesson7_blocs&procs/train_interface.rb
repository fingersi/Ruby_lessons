
require_relative 'text'

class TrainInterface

  def initialize(texts)
    @texts = texts
  end

  def create_train
    loop do
      puts @texts.create_train_number
      train_number = gets.chomp
      Train.valid!(train_number)
      puts @texts.select_train_type
      train_type = gets.chomp
      case train_type
      when '1'
        user_input_train_cars(CargoTrain.new(train_number))
        break
      when '2'
        user_input_train_cars(PassengerTrain.new(train_number))
        break
      else
        puts @texts.wrong_input
      end
    end
  end

  def user_input_train_cars(train)
    loop do
      puts @texts.add_train_cars
      user_input_number = gets.chomp
      break if Train.valid_train_cars!(user_input_number)
      puts @texts.manufacturer
      user_input_manufacturer = gets.chomp
      puts @texts.enter_size
      user_input_size = gets.chomp
      puts @texts.enter_load
      user_input_loaded = gets.chomp
      return unless TrainCar.valid!(user_input_size, user_input_loaded)
    
      if user_input_number.nil?
        puts @texts.wrong_input
      else
        train.add_train_cars(user_input_size.to_i, user_input_loaded.to_i, user_input_manufacturer, user_input_number.to_i )
        break
      end
    end
  end

  def select_train
    loop do
      show_all_trains
      return nil if Train.trains.empty?
      puts @texts.select_train
      user_input = gets.chomp
      if user_input == 'stop'
        break
      elsif !user_input.to_i.nil? && !Train.trains[user_input.to_i].nil?
        return Train.trains[user_input.to_i]
      else
        puts @texts.wrong_input
      end
    end
  end

  def show_all_trains_with_cars
    if Train.trains.any?
      Train.trains.each { |train| show_train(train) }
    else
      puts Texts.no_train
    end
  end

  def show_all_trains
    if Train.trains.any?
      Train.trains.each_with_index do |train, index|
        puts "Index: #{index} Train number: #{train.number} route #{train.route}"
      end
    else
      puts Texts.no_train
    end
  end

  def show_train(train)
    puts "train number: #{train.number}, type: #{
      train.class}, current station: #{
      train.current_station}, route: #{train.route},  manufacturer: #{train.manufacturer}"
      show_train_cars(train)
  end

  def show_train_cars(train)
    train.train_cars.each_with_index do |train_car, index|
      puts "Train car: #{index} number: #{train_car.number} type: #{train_car.type
      } load: #{train_car.load} free: #{train_car.free}"
    end
  end

  def show_prev_station
    if @current_station.nil?
      raise StandardError, 'Trains has no route.'
    else
     self.prev_station.nil? ? (puts 'Train is on departure station on the route.') : 
     (puts "Train's previous station is #{@route[st_index - 1]}")
    end
  end

  def show_current_station
    @current_staion.nil? ? (puts "Train is in nowhere =)") : (puts "Train's current station is: #{@current_station.name}")
  end

  def show_train_cars_number
    puts "train_cars_number: #{train_cars_number}"
  end

  def show_next_station(train)
    if @current_station.nil?
      raise StandardError, 'Trains has no route.'
    else
      next_station = train.next_station
      if next_station.nil?
       puts 'Train is on last station on the route. Please add new route.'
      else 
        puts "Train's next station is #{@route[st_index + 1]}"
      end 
    end
  end

  def move_forward(train)
    next_station = train.next_station
    if next_station.nil?
      puts 'Train is on last station on the route. Please add new route.'
    else
      train.change_station(next_station)
      puts "Train has moved to station: #{train.current_station.name}"
    end
  end

  def move_backward(train)
    prev_station = train.prev_station
    if prev_station.nil?
      puts 'Train is at departion station on the route. You can only move train forward.'
    else
      train.change_station(prev_station)
      puts "Train has moved to station: #{train.current_station.name}."
    end
  end

  def add_train_cars(train, size, loaded, manufacturer = '', number)
    if train.type == 'Cargo'
      number.times do
        train_car = CargoTrainCar.new(size, loaded)
        train_car.manufacturer = manufacturer 
        train.train_cars << train_car
      end
    else
      number.times do
        train_car = PassengerTrainCar.new(size, loaded)
        train_car.manufacturer = manufacturer
        train.train_cars << train_car
      end
    end
    puts "Train #{train.number} has #{train.train_cars.size} train cars"
  end

  def delete_train_cars(train, 
    number)
    if train.type == 'cargo'
      number.times { train.train_cars.slice!(-1, 1)} 
    else
      number.times { train.train_cars.slice!(-1, 1)} 
    end
    puts "#{number} trains cars has been deleted. Now train #{train.number} has #{train.train_cars.size}"
  end

  def show_stations_on_route
    if @current_station.nil?
      raise StandardError, 'Trains has no route.'
    else
      self.stations_on_route.each{ |station| puts station.name if !station.nil?}
    end
  end

end