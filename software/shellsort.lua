#!/usr/bin/env lua

--[[   vim: ts=3:

 $Id: shellsort.lua,v 0.3 2018/10/10 19:33:22 kc4zvw Exp kc4zvw $

  =====================================================================
   
       Author: David Billsbrough <billsbrough@gmail.com>
      Created: Saturday, Sepetember 12, 2009 at 08:58:05 (EDT)
      License: GNU General Public License - version 2
      Version: $Revision: 0.3 $
     Warranty: None
   
     Purpose : ShellSort demo in Lua
   
  ===================================================================== ]]--

function GenerateList(list)
	for i = 1, ArraySize do
		list[i] = math.random(1, MaxNumber)
	end
end

function SwapElements(i, j)
	return j, i
end

function CalcListSize(list)
	return #list
end

function StatusReport(list)
	-- print()
	print(string.format("The size of list is %d.", CalcListSize(list)))
	-- print()
end

function DisplayTitle(num)
	print ""
	print(string.format("Sort a List of Numbers (%d elements)", num))
	print ""
end

function DisplayHeader(title)
	print()
	print(string.format("   %s ", title))
	print "========================="
end

function DisplayList(list)
	for i = 1, ArraySize do
		print(string.format("%8d", list[i]))
	end
	print()
end

-- ###================================================================###

--[[ Shell-Metzner sort
      Adapted from Programming in Pascal, P. Grogono, Addison-Wesley, 1980
      From Borland Pascal Programs for Scientists and Engineers
      by Alan R. Miller, Copyright (C) 1993, SYBEX Inc. ]]--

function ShellSort(list, n)
	jump = n
	while jump > 1 do
		jump = math.floor(jump / 2)
		repeat
			done = true
			for j = 1, (n - jump) do
				i = j + jump
				if list[j] > list[i] then
					list[i], list[j] = SwapElements(list[i], list[j])
					done = false
				end
			end
		until done == true
	end
	return list
end


--[[	
  ###================================================================###
  ###                 Main program begins here                       ###
  ###================================================================### ]]--

ArraySize = 25
MaxNumber = 5000

local Seed = os.time()
math.randomseed(Seed)

unsorted = {}					 	-- create an array
sorted = {}						 	-- create another array

DisplayTitle(ArraySize)
GenerateList(unsorted)			-- fill list of ArraySize numbers (1-5000)
StatusReport(unsorted)
DisplayHeader("Unsorted list")
DisplayList(unsorted)
sorted = ShellSort(unsorted, ArraySize)
DisplayHeader("Sorted list")
DisplayList(sorted)

print()
print "Finished."

--   ***** End of Script *****
