require_relative 'player'
require_relative 'board'

class Game
	attr_accessor :board, :victory_conditions, :current_player, :victor, :players

	def initialize(params = {})
		@board = board
		@victory_conditions = params.fetch(:victory_conditions, false)
		@current_player = params.fetch(:current_player, nil)
		@victor = params.fetch(:victor, nil)
		@players = []
	end
	
	def init
  		self.intro
  		self.select_x_or_o
  		self.select_the_size_of_the_board
  		self.play
	end
	
  	def play
		self.who_goes_first
  		while self.victor == nil && !self.board.is_full?
  			if current_player == 1
  				self.players.first.take_turn(self)
  			else
  				self.players[1].take_turn(self)
  			end
  		end
  		if self.board.is_full?
  			Player.all.each { |player| player.squares = [] }
  			puts "It's a Draw"
	  		puts "Let's Play again!"
  		else
  			Player.all.each { |player| player.squares = [] }
	  		puts "#{self.victor.name} wins!"
	  		puts "Let's Play again!"
  		end
	  		self.victor = nil
	  		self.victory_conditions = false
	  		self.init
	end

	def select_x_or_o
		symbols_selected = false
		loop do
			puts "Please choose which symbol you would like to play with (x or o)"
			puts "Type 'x' or 'o'"
			player_one_symbol = gets.chomp
			if player_one_symbol == "x"
				self.players << PlayerX.new("Player 1",player_one_symbol)
				self.players << PlayerY.new("Computer","o")
				symbols_selected = true
				break
			elsif player_one_symbol == "o"
				self.players << PlayerX.new("Player 1",player_one_symbol)
				self.players << PlayerY.new("Computer","x")
				symbols_selected = true	
				break
			end
		end
		puts "Player 1 has selected: #{self.players.first.symbol}"
		puts "Computer will be: #{self.players[1].symbol}"
	end

	def who_goes_first # randomly selects who goes first
		random = rand(10000000)
		if random.odd?
			self.current_player = 1
  			puts "/////////////////////////////////////////////"
			puts "Player 1 goes first."
  			puts "/////////////////////////////////////////////"
		else
			self.current_player = 2
  			puts "/////////////////////////////////////////////"
			puts "Computer goes first."
  			puts "/////////////////////////////////////////////"
		end
	end


	def intro
  		puts "/////////////////////////////////////////////"
  		puts "/////////////////////////////////////////////"
  		puts "/////////////////WELCOME TO//////////////////"
  		puts "/////////////////////////////////////////////"
  		puts "////////////////TIC-TAC-TOE!!////////////////"
  		puts "/////////////////////////////////////////////"
  		puts "/////////////////////////////////////////////"

  		puts ""
	end

	def select_the_size_of_the_board  	
		# grid size variable
	  	puts "Please select the size of your game board (3-50)"
		board_size = gets.chomp.to_i
		loop do
  			if board_size.between?(3,50)
  				self.board = Board.new(board_size)
  				puts "You've selected a #{board.size} x #{board.size} board"
  				self.board.initial_draw
  				break
  			else
				puts "Please select a valid size of your game board (3-50)"
				board_size = gets.chomp.to_i
  			end
		end
  	end
end