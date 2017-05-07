class Square
	attr_accessor :x, :y, :value
	def initialize(params = {})
		@x = params.fetch(:x)
		@y = params.fetch(:y)
		@value = params.fetch(:value, "|_|")
	end

	def is_free?
		self.value === "|_|"
	end
end