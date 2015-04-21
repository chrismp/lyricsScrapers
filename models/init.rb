## LOCAL DB
DB = Sequel.connect(
	:adapter => 'mysql',
	:user => ARGV[2],
	:password => ARGV[3],
	:host => '127.0.0.1',
	:database => ARGV[4]
)

require_relative 'classes.rb'