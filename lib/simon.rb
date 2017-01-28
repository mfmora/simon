require 'byebug'
require 'colorize'
class Simon
  COLORS = %w(red blue green yellow)

  attr_accessor :sequence_length, :game_over, :seq

  def initialize
    reset_game
  end

  def play
    until @game_over
      take_turn
    end

    game_over_message
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
      print color
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
    @seq.join("-")
  end

  def game_over_message
    puts "Sorry. Game over :("
    puts "The sequence was: "
    puts sequence_to_s
  end

  def reset_game
    @sequence_length = 1
    @game_over = false
    @seq = []
  end
end
