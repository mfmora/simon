require 'byebug'
require 'colorize'
class Simon
  COLORS = %w(red blue green yellow)
  COLOR_CODE = { "red" => :red, "blue" => :blue, "green" => :green, "yellow" => :yellow}

  attr_accessor :sequence_length, :game_over, :seq, :record

  def initialize
    reset_game
    @record = []
  end

  def play
    until @game_over
      take_turn
    end

    game_over_message

    set_record if record?
    show_record unless @record.empty?

    reset_game
  end

  def take_turn
    system("clear")
    show_sequence
    require_sequence

    unless @game_over
      round_success_message
      @sequence_length += 1
    end
  end

  def show_sequence
    add_random_color
    @seq.each do |color|
      print color.colorize(COLOR_CODE[color])
      sleep(1)
      erase_line
    end
  end

  def erase_line
    print "\r"
    print "       "
    sleep(0.5)
    print "\r"
  end

  def require_sequence
    @seq.each do |color|
      system("clear")
      unless color == prompt_color
        @game_over = true
        return
      end
    end
  end

  def prompt_color
    puts "Write the next color in the sequence"
    color = gets.chomp
    raise ArgumentError.new("Invalid input") unless COLORS.include?(color)
    color
  rescue
    puts "Invalid color, try again"
    retry
  end

  def add_random_color
    @seq << COLORS.sample
  end

  def round_success_message
    puts "Great round! You guess #{@sequence_length} colors!"
    sleep(1)
  end

  def sequence_to_s
    @seq.map {|color| color.colorize(COLOR_CODE[color])}.join("-")
  end

  def game_over_message
    puts "Sorry. Game over :(. The sequence was: "
    puts sequence_to_s
  end

  def lowest_record
    @record.last[1]
  end

  def record?
    minimum_record? && (record_not_full? || better_than_lowest?)
  end

  def minimum_record?
    @sequence_length > 2
  end

  def record_not_full?
    @record.count < 10
  end

  def record_full?
    @record.count == 10
  end

  def better_than_lowest?
    @sequence_length - 1 > lowest_record
  end

  def set_record
    add_record(prompt_name)
  end

  def add_record(name)
    @record.pop if record_full? && better_than_lowest?
    position = position_record(@sequence_length - 1)

    @record =
    @record.take(position) +
    [[name, @sequence_length - 1]] +
    @record.drop(position)

    [name, @sequence_length - 1]
  end

  def position_record(value)
    pos = @record.index {|record| record[1] <= value}
    pos.nil? ? @record.length : pos
  end

  def prompt_name
    puts "\nInsert your name to be part of the history of SIMON"
    name = gets.chomp
    name[0..7]
  end

  def show_record
    puts "RECORD HISTORY\n "
    puts "  |Name     |Record"
    puts "--------------------"
    @record.each_with_index do |rec, index|
      name, total = rec
      puts "#{index+1} |#{complete_string(name,8)} | #{total}"
      puts "--------------------"
    end
    nil
  end

  def complete_string(string, n)
    string += " "*(n - string.length)
  end

  def reset_game
    @sequence_length = 1
    @game_over = false
    @seq = []
  end
end
