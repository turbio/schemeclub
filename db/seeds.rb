# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
STDOUT.print 'root user name [root]: '
STDOUT.flush
root_name = STDIN.gets.strip
root_name = root_name.presence || 'root'

STDOUT.print 'root user password [root]: '
STDOUT.flush
root_password = STDIN.gets.strip
root_password = root_password.presence || 'root'

root_user = User.create(
	name: root_name,
	password: root_password,
	parent_id: nil)

STDOUT.puts 'root user created'
STDOUT.puts root_user.inspect
