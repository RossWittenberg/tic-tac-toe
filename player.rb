require_relative 'board'
require_relative 'game'

class Player
	attr_accessor :name, :squares, :symbol
	def initialize(name, symbol)
		@name = name
		@symbol = symbol
		@squares = []
	end

	def self.all
		ObjectSpace.each_object(self).to_a
	end

	def play_a_letter(x,y)
		new_square = Square.new(x:x,y:y)
		self.squares << new_square
	end
	# win detection algorithms:
	def check_for_column_victory(game)
		winning_threshold = game.board.size
		for column_index in (1..winning_threshold)
			active_squares_per_column = self.squares.select { |square| square.x == column_index }
			if active_squares_per_column.count >= winning_threshold
				game.victory_conditions = true
				game.victor = self
			end
		end
	end
	
	def check_for_row_victory(game)
		winning_threshold = game.board.size
		for row_index in (1..winning_threshold)
			active_squares_per_row = self.squares.select { |square| square.y == row_index }
			if active_squares_per_row.count >= winning_threshold
				game.victory_conditions = true
				game.victor = self
			end
		end
	end

	def check_for_diagonal_victory(game)
		winning_threshold = game.board.size
		reverse_counter = winning_threshold
		active_squares_on_left_to_right_diag = self.squares.select { |square| square.x == square.y }
		active_squares_on_right_to_left_diag = []
		for row_index in (1..winning_threshold)
			squares_to_add = self.squares.select { |square| (square.x == reverse_counter && square.y == row_index)  }
			active_squares_on_right_to_left_diag << squares_to_add
			reverse_counter -= 1
		end
		active_squares_on_right_to_left_diag = active_squares_on_right_to_left_diag.reject(&:empty?).uniq
		if active_squares_on_left_to_right_diag.count >= winning_threshold || active_squares_on_right_to_left_diag.count >= winning_threshold
			game.victory_conditions = true
			game.victor = self
		end
	end

	def self.check_for_victory(game)
		self.all.each do |player|
			player.check_for_column_victory(game)
			player.check_for_row_victory(game)
			player.check_for_diagonal_victory(game)
		end	
	end

	def clear_board
		self.squares = []
	end
end

class PlayerX < Player	#inheritance
	def take_turn(game) #polymorphism
		puts "Player #{game.current_player.to_s}'s turn."
		puts "Please select a square using x and y coordinates"
		puts "First, enter the x coordinate: "
		x = gets.chomp.to_i
		loop do
  			if x.between?(1,game.board.size)
				puts "Now, enter an y coordinate: "
				y = gets.chomp.to_i
  				if y.between?(1,game.board.size)
					@square = game.board.squares.find { |square| square.x == x && square.y == y }
					if @square.is_free?
						if game.current_player == 1
							@square.value = "|#{self.symbol}|"
							game.players.first.play_a_letter(@square.x, @square.y)
							game.current_player == 2 ? game.current_player = 1 : game.current_player = 2
							game.board.draw
						end
						Player.check_for_victory(game)
						break
					else 
						puts "This square is taken. Please select another one."
						self.take_turn(game)
						break
					end	
				else
					puts "Please enter a valid y coordinate"
					y = gets.chomp.to_i
				end 
  			else
				puts "Please enter a valid x coordinate"
				x = gets.chomp.to_i
  			end
		end
	end
end

class PlayerY < Player #inheritance
	def take_turn(game) #polymorphism
		array_of_board_size = (1..game.board.size).to_a
		random_x = array_of_board_size.sample
		random_y = array_of_board_size.sample
		# random selection of square for move
		@square = game.board.squares.find { |square| square.x == random_x && square.y == random_y }
		while !@square.is_free?
			random_x = array_of_board_size.sample
			random_y = array_of_board_size.sample
			@square = game.board.squares.find { |square| square.x == random_x && square.y == random_y }
		end
		@square.value = "|#{self.symbol}|"
		game.players[1].play_a_letter(@square.x, @square.y)
		game.current_player == 1 ? game.current_player = 2 : game.current_player = 1
		puts "The Computer has played."
		game.board.draw
		Player.check_for_victory(game)
	end
end