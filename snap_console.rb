#!/usr/bin/ruby

require 'snapcat'
require 'io/console'

$commands = ["get snaps - download snaps to working directory", 
						"get stories - download stories to working directory",
					  "show/search friends - show/search friends list",
					  "info - print info on a specified user",
					  "add friend - add a friend",
					  "best friends - show best friends",
					  "delete friend - delete a friend",
					  "show stats - show account statistics",
					  "banner - show the banner",
					  "version - show program version",
					  "quit - quit snapchat console",
					  "help - this message"]

def main()
	STDIN.flush
	STDOUT.flush
	get_input()
end

def construction()
	 puts "Under construction. Check back soon! -Michael"
end


def newline()
	print ">> "
end

def show_best()
	puts "\n"
	data = $snap_instance.user.data
	bfs = data[:bests]
	puts "------------"
	puts "Best friends"
	puts "------------"
	bfs.each do |friend|
		puts "#{friend}"
  end
	puts "------------\n"
end


def eval(input)
	if input === "help"
		printHelp()
	elsif input === "exit" || input === "quit"
		exit()
	elsif input === "get snaps"
		get__snaps()
	elsif input === "best friends"
		show_best()
	elsif input === "get stories"
		get__stories()
	elsif input === "show friends" || input === "search friends"
		showsearchfriends()
	elsif input === "show stats"
		showStats()
	elsif input === "add friend"
		add_fr = $stdin.gets.chomp
		addfriend(add_fr)
	elsif input === "version"
		printVersion()
	elsif input === "banner"
		banner()
	elsif input === "delete friend"
		print "User: "
		del_fr = $stdin.gets.chomp
		deletefriend(del_fr)
	elsif input === "info"
		print "User: "
		user = $stdin.gets.chomp
		getinfo(user)
	else
		puts "Didn't recognize that"
	end		
end

def printHelp()
	puts "The following is a list of commands"
	$commands.each {|x| puts x}
end

def get_input()
	newline()
	inp = $stdin.gets.chomp
	eval(inp)
	main()
end

def showStats()
	data = $snap_instance.user.data
  reqs = data[:requests]
  if reqs.length > 0
  	puts "New friend requests!\n"
  	reqs.each {|user| puts "#{user}"}
  end
  puts "\n"
  puts "User Score: #{data[:score]}"
  frs = data[:friends]
  numfrs = 0
  frs.each {|key, val| numfrs += 1}
  puts "Number of friends: #{numfrs}"
  puts "Registered phone number: #{data[:mobile]}"
  puts "Registered email: #{data[:email]}"
  puts "Total Number of Snaps Sent: #{data[:sent]}"
  puts "Total Number of Snaps Receieved: #{data[:received]}"
  puts "\n"
end

def deletefriend(username)
 $snap_instance.user.friends.each do |friend|
	if friend.display_name === username || friend.username === username
		$snap_instance.delete_friend(friend)
	else
		puts "Couldn't find #{username}. I guess you don't have to delete them!"
	end
 end
end
def addfriend(username)
$snap_instance.user.friends.each do |friend|
		if friend.username === username
			puts "Already have this user as a friend!"
			return
		end
	end
	resp = $snap_instance.add_friend(username)
	puts resp #in testing
end

def getinfo(user)
 construction()
end

def printVersion()
	puts "Version 0.0.1"
end

def showsearchfriends()
	print "Enter name to search for (blank for show all): "
	search = $stdin.gets.chomp
end

def get__stories()
 stories = $snap_instance.get_stories
 stories.data.each do |key, value|
 		unless key != :friend_stories
 			value.each do |val|
 				val.each do |ne|
 					if ne[1].class == Array
 						n = ne[1]
 						n.each do |part|
 							extracted = part[:story]
 						end
 					end
 				end
 			end
 		end
 end
end

def get__snaps()
 snap = $snap_instance.user.snaps_received
 snap.each do |snapz|
	 media_response = $snap_instance.media_for(snapz.id)
   media = media_response.data[:media]
 	 print "New snap from: #{snapz.sender}\n"
 	 f = File.open("#{$snapdir}/#{snapz.id[1..3] + snapz.sender}", "w")
 	 f.write(media)
 end
end

unless ARGV.length === 2
	unless ARGV.length === 1
		puts "Usage: ruby snapcli [username] [password]"
		puts "May leave password blank to get secret input"
		exit()
	end
	print "Password: "
	username = ARGV[0]
	password = STDIN.noecho(&:gets)
	print "\n"
end

if ARGV.length === 2
	password = ARGV[1]
	username = ARGV[0]
end

def banner()
 puts "\n\n"
 puts "           ___                                                              "
 puts "          (   )  .-.                                                        "
 puts "  .--.     | |  ( __)                 .--.     ___ .-.     .---.     .-..   "
 puts " /    \\    | |  (''')               /  _  \\   (   )   \\   / .-, \\   /    \\  "
 puts "|  .-. ;   | |   | |    .------.   . .' `. ;   |  .-. .  (__) ; |  ' .-,  ; "
 puts "|  |(___)  | |   | |   (________)  | '   | |   | |  | |    .'`  |  | |  . | "
 puts "|  |       | |   | |               _\\_`.(___)  | |  | |   / .'| |  | |  | | "
 puts "|  | ___   | |   | |              (   ). '.    | |  | |  | /  | |  | |  | | "
 puts "|  '(   )  | |   | |               | |  `\\ |   | |  | |  ; |  ; |  | |  ' | "
 puts "'  `-' |   | |   | |               ; '._,' '   | |  | |  ' `-'  |  | `-'  ' "
 puts " `.__,'   (___) (___)               '.___.'   (___)(___) `.__.'_.  | \\__.'  "
 puts "                                                                   | |      "
 puts "                                                                  (___)     "
end
banner()
print "create a directory for this username? (y/n) "
ans = $stdin.gets.chomp
if ans === "y" || ans === "Y" || ans === "yes" || ans === "Yes"
	unless Dir.exists? "#{username}"
		p = Dir.pwd
		Dir.mkdir("#{p}/#{username}")
		$pr = "#{p}/#{username}"
		$snapdir = "#{$pr}/snaps"
		$storydir = "#{$pr}/stories"
		Dir.mkdir("#{$snapdir}")
		Dir.mkdir("#{$storydir}")
	end
else
	$pr = Dir.pwd
	$snapdir = $pr
	$storydir = $pr
end

$snap_instance = Snapcat::Client.new(username)
resp = $snap_instance.login(password.chomp)
if resp.data[:logged] === false
 unless resp.data[:message].include? "suspicious"
	puts "Wrong password supplied"
 else
  puts resp.data[:message]
 end
 exit()
end

#puts "Successfully logged in"
main()
