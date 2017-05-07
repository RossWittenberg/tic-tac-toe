require_relative 'square'

class Board
	attr_accessor :size, :squares

	def initialize(size)
		@size = size
	end

	def initial_draw
		self.squares = []
		size = self.size
		i = 1
		until i > size
			j = 0
			while j < size
				square = Square.new({x:j+1,y:i})
				self.squares << square
				j += 1
			end
			i += 1
		end
		self.draw
	end

	def draw
		size = self.size
		i = 1
		self.squares.each do |square|
			print square.value
			if square.x >= size
				puts "\n"
			end
		end
	end

	def is_full?
		free_squares = []
		free_squares << self.squares.select{ |sq| sq.is_free? }
		free_squares.reject(&:empty?).count <= 0
	end

end