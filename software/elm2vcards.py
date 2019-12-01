#!/usr/bin/python3 -u

###----------------------------------------------------------------###
#
#    Author : David Billsbrough <kc4zvw@earthlink.net>
#   Created : Tueday, 17 July 2001 at 12:15  (EDT)
#   License : GNU General Public License - version 2
#   Version : $Revision: 0.4 $
#  Warranty : None
#
#   Purpose : Convert an Elm address book for use with
#           : GNOME address book.
#
#  $Id: elm2vcard,v 0.4 2001/07/17 15:20:16 kc4zvw Exp kc4zvw $
#
###----------------------------------------------------------------###

import os, string, time

def get_home_dir():
	myHOME = os.environ["HOME"]
	print("My $HOME directory is %s.\n" % myHOME)
	return myHOME

def get_timestamp():
	# return local date in format of "2001-05-17T01:48:21"
	timetuple = time.localtime(time.time())
	return time.strftime("%Y-%m-%dT%H:%M:%S", timetuple)

def delete_comment(name, pos):
	return name[0:pos]

def get_firstname(name, pos):
	return name[pos+2:]

def get_lastname(name, pos):
	return name[0:pos]

def get_fullname(first_name, last_name):
	full_name = first_name + " " + last_name
	return full_name

def display_entry(alias, name, email):
	print("Converting %s (%s) <%s>." % (name, alias, email))

def write_vcard_entry(alias, first, last, email):
	fullname = get_fullname(first, last)
	timestamp = get_timestamp()
	
	output.write("BEGIN:VCARD\n")
	output.write("FN:%s\n" % fullname)
	output.write("N:%s;%s\n" % (last, first))
	output.write("REV:%s\n" % timestamp)
	output.write("EMAIL;INTERNET:%s\n" % email)
	output.write("CATEGORIES;QUOTED-PRINTABLE:%s\n" % alias)
	output.write("END:VCARD\n")
	output.write("\n")

def process_line(aline):
	pos1 = pos2 = 0
	first = last = ""

	list = string.split(aline[:-1], " = ")

	alias = list[0]
	name = list[1]
	email = list[2]

	pos1 = string.find(name, ',')				# search for a comma
	pos2 = string.find(name, ';')				# search for a semicolon
	#print("comma at '%d'; semicolon at '%d'" % (pos1, pos2))

	if (pos1 > 0) :
		name = delete_comment(name, pos1)

	if (pos2 > 0) :
		first = get_firstname(name, pos2)
		last = get_lastname(name, pos2)
		name = get_fullname(first, last)

	display_entry(alias, name, email)				# display progress
	write_vcard_entry(alias, first, last, email)	# write single entry


###-------------------- Main Routine --------------------###

home = get_home_dir()

elm = home + os.sep + ".elm" + os.sep + "aliases.text"
vcard = home + os.sep + "vcards.text"

print("The Elm mail alias file is %s." % elm)
print("The GNOME address book import file is %s." % vcard)
print("")

input = open(elm, 'r')
output = open(vcard, 'w')

for line in input.readlines():
	process_line(line)

input.close() 
output.close()

print("Conversion completed.")

# End of Program
