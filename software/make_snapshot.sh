#!/bin/bash
#
# RCS info: $Id: make_snapshot.sh,v 0.2 2022/06/10 10:25:20 root Exp root $
#
# ----------------------------------------------------------------------
# Mike's handy rotating-filesystem-snapshot utility
# ----------------------------------------------------------------------
# This needs to be a lot more general, but the basic idea is it makes
# rotating backup-snapshots of /home whenever called
# ----------------------------------------------------------------------

unset PATH	# suggestion from H. Milz: avoid accidental use of $PATH

# ------------- System commands used by this script --------------------

CAT=/usr/bin/cat
DATE=/usr/bin/date
ECHO=/bin/echo
ID=/usr/bin/id

CP=/bin/cp
MOUNT=/bin/mount
MV=/bin/mv
RM=/bin/rm
TEE=/usr/bin/tee
TOUCH=/bin/touch

MAILER=/usr/bin/mailx
RSYNC=/usr/bin/rsync


# ------------- File locations -----------------------------------------

MOUNT_DEVICE=/dev/hdb1
SNAPSHOT_RW=/root/snapshot
EXCLUDES=/usr/local/etc/backup_exclude

# ------------- Email Options ------------------------------------------

ADMINS="root@localhost kc4zvw@localhost"
LOG=/tmp/rsnapshot.$$.log
MYHOST=$(/usr/bin/hostname)

# ------------- The script itself --------------------------------------

# Make sure we're running as root

if (( `$ID -u` != 0 )); then
{
	$ECHO "Sorry, you must be Superuser (root).  Exiting ...";
	exit
}
fi

# Attempt to remount the RW mount point as RW; else abort

#$MOUNT -o remount,rw $MOUNT_DEVICE $SNAPSHOT_RW ;
#if (( $? )); then
#{
#	$ECHO "Snapshot: could not remount $SNAPSHOT_RW readwrite";
#	exit
#}
#fi

echo
echo "Creating log file"

$TOUCH $LOG

echo -e "Running $0\n" | $TEE -a $LOG

# Rotating snapshots of /home (fixme: this should be more general)

# Step 1: Delete the oldest snapshot, if it exists:
if [ -d $SNAPSHOT_RW/home/hourly.3 ] ; then			
	$RM -rf $SNAPSHOT_RW/home/hourly.3 ;			
fi

# Step 2: Shift the middle snapshots(s) back by one, if they exist
if [ -d $SNAPSHOT_RW/home/hourly.2 ] ; then			
	$MV $SNAPSHOT_RW/home/hourly.2 $SNAPSHOT_RW/home/hourly.3 
fi

if [ -d $SNAPSHOT_RW/home/hourly.1 ] ; then			
	$MV $SNAPSHOT_RW/home/hourly.1 $SNAPSHOT_RW/home/hourly.2 	
fi

# Step 3: Make a hard-link-only (except for dirs) copy of the latest snapshot, if that exists
if [ -d $SNAPSHOT_RW/home/hourly.0 ] ; then			
	$CP -al $SNAPSHOT_RW/home/hourly.0 $SNAPSHOT_RW/home/hourly.1 	
fi

# Step 4: rsync from the system into the latest snapshot (notice that
# rsync behaves like cp --remove-destination by default, so the destination
# is unlinked first.  If it were not so, this would copy over the other
# snapshot(s) too!

$RSYNC									\
	-va --delete --delete-excluded		\
	--exclude-from="$EXCLUDES"			\
	/home/ $SNAPSHOT_RW/home/hourly.0 	\
	| $TEE -a $LOG

# Step 5: update the mtime of hourly.0 to reflect the snapshot time

$TOUCH $SNAPSHOT_RW/home/hourly.0

# and thats it for home.

# Now remount the RW snapshot mountpoint as readonly

#$MOUNT -o remount,ro $MOUNT_DEVICE $SNAPSHOT_RW 
#if (( $? )); then
#{
#	$ECHO "Snapshot: could not remount $SNAPSHOT_RW readonly";
#	exit
#}
#fi

## As you might have noticed above, I have added an excludes list to the
## rsync call. This is just to prevent the system from backing up garbage
## like web browser caches, which change frequently (so they'd take up
## space in every snapshot) but would be no loss if they were accidentally
## destroyed.


# ------------- Finish up script ---------------------------------------

$ECHO -ne "\nFinishing up" | $TEE -a $LOG
$DATE +" on %A, %B %d, %Y at %H:%M:%S %p (%Z)" | $TEE -a $LOG


# Send out an email reminder of work completed

# Email results

## 30.Jan.01 -- Art Mulder - strip the log file of all the filenames
#cat $LOG | sed -e "/^## /d" |  mail -s "$MYHOST rsync backup log" $ADMINS
$CAT $LOG | $MAILER -s "Hourly rsync backup completed for $MYHOST" $ADMINS

echo
echo "Removing old log file ..."
$RM $LOG

# End of Script
