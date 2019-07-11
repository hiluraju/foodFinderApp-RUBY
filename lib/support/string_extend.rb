# This helper opens up core Ruby String Class , inorder to add a new method to all strings

class String
	# Ruby has a capitailize method (used below) which capitalize First letter of a string
	# But inorder to capitialize First letter of every words we have to write our own
	def titleize
		self.split(' ').collect {|word| word.capitalize}.join(" ")
	end

end 