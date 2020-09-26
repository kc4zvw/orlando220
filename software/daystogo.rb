#!/usr/bin/ruby

#
#  Author: David Billsbrough <kc4zvw@earthlink.net>
# Revised: Friday, March 10, 2017 at 11:25:52 AM (EST)
#
#  $Id: daystogo.rb,v 0.5 2005/12/03 01:45:06 kc4zvw Exp kc4zvw $
#

require 'date'

file = ".calendar"
Today = Date::today

def get_home_dir
    myHOME = ENV["HOME"]
    #print "My $HOME directory is #{myHOME}.\n"
    return myHOME
end

def process_line(aline)
        aline.chomp!
        #print "line: #{aline}\n"

        (eventDate, eventName) = aline.split(/:/)
        (year, month, day) = (eventDate.split("/"))
        dateTarget = Date::new(year.to_i, month.to_i, day.to_i)

        temp = dateTarget - Today
        dayCount = temp.to_i

        if (dayCount <= -2) then
                puts "It was #{dayCount.abs} days ago since #{eventName}."
        elsif (dayCount == -1)
                puts "Yesterday was #{eventName}."
        elsif (dayCount == 0)
                puts "Today is #{eventName}."
        elsif (dayCount == 1)
                puts "Tomorrow is #{eventName}."
        else
                puts "There are #{dayCount} days until #{eventName}."
        end
end

def formattedDate(d)
        date = "#{Date::DAYNAMES[d.wday]}, #{Date::MONTHNAMES[d.mon]} " \
                "#{d.day}, #{d.year}"
        return date
end

###==================================###
##      Main program begins here      ##
###==================================###

puts
puts "Today's date is #{formattedDate(Today)}."
puts

home = get_home_dir()
calendarFile = home + '/' + file

begin
        input = File.new(calendarFile, mode='r')
rescue
        print "Couldn't open #{calendarFile} for reading dates.\n"
        exit 2
end

for aline in input.readlines()
        process_line(aline)
end

input.close

puts
puts "End of report"

# End of script
