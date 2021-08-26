private 

class Player
  attr_accessor :name, :symbol, :number_of_wins
  
  def initialize(name, symbol, number_of_wins)
    @name = name
    @symbol = symbol
    @number_of_wins = number_of_wins
  end

  def to_s
    "Player: #{name}, Number of wins: #{number_of_wins}"
  end

end

class TicTacToe
  def initialize
    @game = []
    @players = []
  end
  
  def set_up_game
    for i in 1..2
      puts
      print "Player #{i} enter your name: "
      name = gets.chomp
      if i == 1

        while true
          print "Player 1 choose your symbol ('X' or 'O'): "
          symbol = gets.chomp.upcase
          if symbol == "X" || symbol == "O"
            break
          end
          input_error()
        end

      else
        case @players[0].symbol
        when "X" then symbol = "O"
        when "O" then symbol = "X"
        end
      end
      @players << Player.new(name, symbol, 0)
    end
    puts "\nHow to play: Enter grid location (e.g 'A1')"
    start()
  end

  private

  def start
    number_of_plays = 0
    keep_track_player = 0
    @game = Array.new(3){Array.new(3," ")}

    until number_of_plays == 9
      board()
        track_player(keep_track_player)
        if evaluate()
          board()
          break
        end
    keep_track_player += 1
    number_of_plays += 1
    end

    check_winner(number_of_plays, keep_track_player, evaluate())
    restart()
  end

  def check_winner(num_plays, keep_track, evaluate)
    if num_plays == 9 && evaluate == false
      board()
      puts "No winner!"
    elsif keep_track % 2 == 0
      @players[0].number_of_wins += 1
      puts "#{@players[0].name} won!"
    else 
      @players[1].number_of_wins += 1
      puts "#{@players[1].name} won!"
    end
  end

  def track_player(value)
    choice = ""

    if value % 2 == 0
      check_input(@players[0])
    else
      check_input(@players[1])
    end
  end

  def check_input(player)
    while true
      print "#{player.name} play: "
      choice = gets.chomp.upcase

      unless play(choice, player) == -1
        break
      else
        input_error()
      end

    end
  end

  def restart
    print "\nPlay again? ('Y' or 'N'): "

    case gets.chomp.upcase
      when "Y" then start()
      when "N" then puts "_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _\n\n\tFinal results: \n#{print_info()}\n_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _"
        exit(0)
    else 
      input_error()
      restart()
    end
  end

  def print_info
    @players[0].to_s.concat("\n" + @players[1].to_s)
  end

  def input_error
    puts "Invalid input!"
  end

  def play(choice, player)
    choice_tokens = choice.split("")
  
    case choice_tokens[0]
    when "A" then choice_tokens[0] = 0
    when "B" then choice_tokens[0] = 1
    when "C" then choice_tokens[0] = 2
    end

    case choice_tokens[1]
    when "1" then choice_tokens[1] = 0
    when "2" then choice_tokens[1] = 1
    when "3" then choice_tokens[1] = 2
    end
   
    if option_is_empty?(choice_tokens[1], choice_tokens[0])
      case choice
      when "A1" then @game[0][0] = player.symbol
      when "A2" then @game[1][0] = player.symbol
      when "A3" then @game[2][0] = player.symbol
      when "B1" then @game[0][1] = player.symbol
      when "B2" then @game[1][1] = player.symbol
      when "B3" then @game[2][1] = player.symbol
      when "C1" then @game[0][2] = player.symbol
      when "C2" then @game[1][2] = player.symbol
      when "C3" then @game[2][2] = player.symbol
      else
      -1
      end
    else
      -1
    end
  end

  def board
    puts
    puts "    A   B   C"
    puts "1 |#{@game[0].to_s.gsub(", ","|").sub("[","").sub("]","")}|"
    puts "  -------------"
    puts "2 |#{@game[1].to_s.gsub(", ","|").sub("[","").sub("]","")}|"
    puts "  -------------"
    puts "3 |#{@game[2].to_s.gsub(", ","|").sub("[","").sub("]","")}|"
    
    puts
  end

  def evaluate
    game_over = false
    if check_diagonal(1, 1) || check_horizontal(0, 1) || check_horizontal(1, 1) || check_horizontal(2, 1) || check_vertical(1, 0) || check_vertical(1, 1) || check_vertical(1, 2)
      game_over = true
    end
    game_over
  end

  def check_diagonal(row, column)
    if self.option_is_empty?(row, column)
      return false
    else
    (@game[row][column].eql?(@game[row - 1][column - 1]) && @game[row][column].eql?(@game[row + 1][column + 1])) || 
    (@game[row][column].eql?(@game[row - 1][column + 1]) && @game[row][column].eql?(@game[row + 1][column - 1]))
    end
  end

  def check_horizontal(row, column)
    if self.option_is_empty?(row, column)
      return false
    else
    @game[row][column].eql?(@game[row][column - 1]) && @game[row][column].eql?(@game[row][column + 1])
    end
  end

  def check_vertical(row, column)
    if self.option_is_empty?(row, column)
      return false
    else
      @game[row][column].eql?(@game[row + 1][column]) && @game[row][column].eql?(@game[row - 1][column])
    end
  end

  def option_is_empty?(row, column)
    @game[row][column].eql?(" ")
  end
end

game = TicTacToe.new
game.set_up_game