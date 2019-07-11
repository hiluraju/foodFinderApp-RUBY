require 'restaurant'
require 'support/string_extend'

class Guide

	class Config
		@@actions = ['list','add','find','quit']
		def self.actions; @@actions; end
	end

	def initialize(path=nil)
		# Locate the restaurant file at that path
		Restaurant.filepath = path
		if Restaurant.file_useable?
		#	puts "Found File"
		# Or create a new file
		elsif Restaurant.create_file
		#	puts "Created File"
		# Exit if create fails
		else
		#	puts "Exiting !!!"
			exit!
		end
	end

	def launch!
		introduction
		# Action loop
		result = nil
		until result == :quit
			action,args = get_action
			# 	Do that action
			result = do_action(action,args)
			# Repeat Until User quits
		end
		conclusion
	end

	def introduction
		puts "<<< WELCOME TO FOOD FINDER >>>" 
	end

	def get_action
			action = nil
			# Keep asking for valid user input
			until Guide::Config.actions.include?(action)
				puts "Actions: " + Guide::Config.actions.join(", ") if action
				print "> "
				user_response = gets.chomp
			#	action = user_response.downcase.strip //modified for find action
				args = user_response.downcase.strip.split(' ')
				action = args.shift
			end
			return action, args			
	end

	def do_action(action,args=[])
		case action
		when 'list'
			list(args)
		when 'add'
			add
		when 'find'
			keyword = args.shift
			find(keyword)
		when 'quit'
			return :quit
		else
			puts "\n Invalid Command !!!"
		end
	end

	#def list
	#	output_action_header("LISTING RESTAURANTS")
	#	restaurants = Restaurant.saved_restaurants
		# restaurants.each do |rest|
		# 	puts rest.name + " | " + rest.cuisine + " | " + rest.formatted_price
		# end
	#	output_restaurant_table(restaurants)
	#end

	def list(args = [])
		sort_order = args.shift
		sort_order = args.shift if sort_order == 'by'
		sort_order = "name" unless ['name','cuisine','price'].include?(sort_order)
		output_action_header("LISTING RESTAURANTS")
		restaurants = Restaurant.saved_restaurants
		restaurants.sort! do |r1,r2|
			case sort_order
			when 'name'
				r1.name.downcase <=> r2.name.downcase
			when 'cuisine'
				r1.cuisine.downcase <=> r2.cuisine.downcase
			when 'price'
				r1.price.to_i <=> r2.price.to_i 
			end
		end
		output_restaurant_table(restaurants)
		puts "Sort Using: 'list cuisine' or 'list by cuisine' or 'list price' or 'list by price' or 'list name' or 'list by name'\n\n"
	end

	def add
		output_action_header("ADD A NEW RESTAURANT")
		restaurant = Restaurant.build_using_questions

		if restaurant.save
			puts " Restaurant Added Successfully \n"
		else
			puts " Restaurant Addition Failed !!! \n"
		end
	end

	def find(keyword = "")
		puts output_action_header("FIND A RESTAURANT")
		if keyword
			restaurants = Restaurant.saved_restaurants
			found = restaurants.select do |rest|
				rest.name.downcase.include?(keyword.downcase) ||
				rest.cuisine.downcase.include?(keyword.downcase) ||
				rest.price.to_i <= keyword.to_i
			end
			output_restaurant_table(found)
		else
			puts "Find Using A Key Phrase To Search Restaurant List"
			puts "Example : 'find Hotelname' \n \n"
		end
	end

	def conclusion
		puts "<<< THANK YOU >>>"
	end

	private

	def output_action_header(text)
		puts "\n #{text.upcase.center(60)} \n \n"
	end

	def output_restaurant_table(restaurants = [])
		print " " + " Name".ljust(30)
		print " " + " Cuisine".ljust(20)
		print " " + " Price".rjust(6) + "\n"
		puts "-" * 60
		restaurants.each do |rest|
			line = " " << rest.name.titleize.ljust(30)
			line << " " << rest.cuisine.titleize.ljust(20)
			line << " " << rest.formatted_price.rjust(6)
			puts line
		end
		puts "No Listings Found" if restaurants.empty?
		puts "-" * 60
	end

end