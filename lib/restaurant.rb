require 'support/number_helper'

class Restaurant
	include NumberHelper

	@@filepath = nil

	# Setter metod
	def self.filepath=(path=nil)
		@@filepath = File.join(APP_ROOT, path)
	end

	attr_accessor :name, :cuisine, :price

	def self.file_exists?
		# Class should know if the restaurant file exists
		if @@filepath && File.exists?(@@filepath)
			return true
		else		
			return false
		end
	end

	def self.file_useable?
		return false unless @@filepath
		return false unless File.exists?(@@filepath)
		return false unless File.readable?(@@filepath)
		return false unless File.writable?(@@filepath)
		return true
	end

	def self.create_file
		# Create the restaurant file
		File.open(@@filepath, 'w') unless file_exists?
		return file_useable?
	end

	def self.saved_restaurants
		# Read the restaurant file
		restaurants = []
		if file_useable?
			file = File.new(@@filepath, 'r')
			file.each_line do |line|
				restaurants << Restaurant.new.import_line(line.chomp)
			end
			file.close
		end
		# Return instances of restaurant
		return restaurants
	end

	def self.build_using_questions
		args = {}

		print "Restaurant Name: "
		args[:name] =  gets.chomp.strip
		print "Cuisine Type: "
		args[:cuisine] =  gets.chomp.strip
		print "Average price: "
		args[:price] = gets.chomp.strip

		return self.new(args) 
	end

	def initialize(args={})
		@name    = args[:name]    || ""
		@cuisine = args[:cuisine] || ""
		@price   = args[:price]   || ""
	end

	def import_line(line)
		line_array = line.split("\t")
		@name,@cuisine,@price = line_array
		return self # Returning the object itself
	end

	def save
		return false unless Restaurant.file_useable?
		File.open(@@filepath, 'a') do |file|
			file.puts "#{[@name, @cuisine, @price].join("\t")}\n"
		end
		return true
	end

	def formatted_price
		number_to_currency(@price)
	end
end