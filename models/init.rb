## LOCAL DB
DB = Sequel.connect(
	:adapter => 'mysql',
	:user => ARGV[1],
	:password => ARGV[2],
	:host => '127.0.0.1',
	:database => ARGV[3]
)

require_relative 'classes.rb'