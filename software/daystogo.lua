#!/usr/bin/env lua53

--[[ vim: nowrap:

  *************************************************************************
  ***
  ***    Author: David Billsbrough <kc4zvw@earthlink.net>
  ***   Created: Saturday, August 1, 2009 at 08:26 (EDT)
  ***   License: GNU General Public License -- version 2
  ***   Version: $Revision: 0.70 $
  ***  Warranty: None
  ***   Purpose: Calculate the difference in days between two dates
  ***
  ***  $Id: daystogo.lua,v 0.70 2019/01/15 07:25:41 kc4zvw Exp kc4zvw $
  ***
  ************************************************************************* ]]--

sf = string.format

function get_home_dir()
        local myHOME = os.getenv("HOME")
        --print(sf("My $HOME directory is %s.", myHOME))
        return myHOME
end

function get_hostname()
        local myHost = os.getenv("HOSTNAME")
        --print(sf("My $HOSTNAME is %s.", myHost))
        return myHost
end

function formatted_date(d)
        return os.date("%A, %B %d, %Y at %H:%M", d)
end

function process_line(aline)
        local count = string.find(aline, ":")
        local eventDate = string.sub(aline, 1, count - 1)
        local eventName = string.sub(aline, count + 1, -1)
        --print(sf("  Date: %s", eventDate))
        --print(sf(" Event: %s", eventName))

        local year = string.sub(eventDate, 1, 4)
        local month = string.sub(eventDate, 6, 7)
        local day = string.sub(eventDate, 9, 10)

        local t = os.date('*t')
        t.year, t.month, t.day = year, month, day
        local dateTarget = os.time(t)
        local dayDelta = os.difftime(dateTarget, Today) / (60 * 60 * 24)
        local dayCount = math.floor(dayDelta + 0.5)

        if dayCount <= -2 then
                print(sf("It was %s days ago since %s.", math.abs(dayCount), eventName))
        elseif dayCount == -1 then
                print(sf("Yesterday was %s.", eventName))
        elseif dayCount == 0 then
                print(sf("Today is %s.", eventName))
        elseif dayCount == 1 then
                print(sf("Tomorrow is %s.", eventName))
        else
                print(sf("There are %s days until %s.", dayCount, eventName))
        end
end

-- ###========== Main program begins here ==========###

Today = os.time()

local home = get_home_dir()
local file = ".calendar"
local calendarFile = home .. '/' .. file
local hostname = get_hostname()

print ""
print "Days To Go Calculator  (Lua version)"
print ""
print(sf("Today is %s (local).", formatted_date(Today)))
print ""
print(sf("Here is the '%s' machine.", hostname))
print ""

local input = assert(io.open(calendarFile, 'r'), "Could not open input file for reading dates.")

for line in io.lines(calendarFile) do
        process_line(line)
end

io.close(input)

print ""
print "End of report"

os.exit(0)

-- ### End of Script ###
