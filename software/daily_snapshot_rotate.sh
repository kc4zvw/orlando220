#!/bin/bash
#
# RCS info: $Id: daily_snapshot_rotate.sh,v 0.2 2022/06/10 10:29:19 root Exp root $
#
# ----------------------------------------------------------------------
# Mike's handy rotating-filesystem-snapshot utility: daily snapshots
# ----------------------------------------------------------------------
# Intended to be run daily as a cron job when hourly.3 contains the
# midnight (or whenever you want) snapshot; say, 13:00 for 4-hour snapshots.
# ----------------------------------------------------------------------

unset PATH

# ------------- System commands used by this script --------------------

ID=/usr/bin/id
ECHO=/bin/echo

MOUNT=/bin/mount
RM=/bin/rm
MV=/bin/mv
CP=/bin/cp
TEE=/usr/bin/tee
TOUCH=/usr/bin/touch

# ------------- File locations -----------------------------------------

MOUNT_DEVICE=/dev/hda4;
SNAPSHOT_RW=/root/snapshot

# ------------- Mail opions --------------------------------------------

ADMINS=root@localhost
LOG=/tmp/rsnapshot-daily.$$.log

# ------------- The script itself --------------------------------------

# Make sure we're running as root

if (( `$ID -u` != 0 )); then
{
	 $ECHO "Sorry, must be Superuser (root).  Exiting ..."
	 exit
}
fi

# Attempt to remount the RW mount point as RW; else abort
#$MOUNT -o remount,rw $MOUNT_DEVICE $SNAPSHOT_RW 
#if (( $? )); then
#{
#	$ECHO "snapshot: could not remount $SNAPSHOT_RW readwrite"
#	exit
#}
#fi

echo
echo "Creating log file"

$TOUCH $LOG

# Step 1: Delete the oldest snapshot, if it exists:

if [ -d $SNAPSHOT_RW/home/daily.2 ] ; then			
	$RM -rf $SNAPSHOT_RW/home/daily.2 				
fi 

$ECHO "Step one complete." | $TEE -a $LOG

# Step 2: shift the middle snapshots(s) back by one, if they exist

if [ -d $SNAPSHOT_RW/home/daily.1 ] ; then			
	$MV $SNAPSHOT_RW/home/daily.1 $SNAPSHOT_RW/home/daily.2 
fi

if [ -d $SNAPSHOT_RW/home/daily.0 ] ; then			
	$MV $SNAPSHOT_RW/home/daily.0 $SNAPSHOT_RW/home/daily.1
fi

$ECHO "Step two complete." | $TEE -a $LOG

# Step 3: Make a hard-link-only (except for dirs) copy of
# hourly.3, assuming that exists, into daily.0

if [ -d $SNAPSHOT_RW/home/hourly.3 ] ; then	
	$CP -al $SNAPSHOT_RW/home/hourly.3 $SNAPSHOT_RW/home/daily.0 
fi

$ECHO "Step three complete." | $TEE -a $LOG

# Note: do *not* update the mtime of daily.0; it will reflect
# when hourly.3 was made, which should be correct.

# Now remount the RW snapshot mountpoint as readonly

#$MOUNT -o remount,ro $MOUNT_DEVICE $SNAPSHOT_RW ;
#if (( $? )); then
#{
#	$ECHO "Snapshot: could not remount $SNAPSHOT_RW readonly"
#	exit
#}
#fi

# Send out an email reminder of work completed

# Email results
##cat $LOG | mail -s "$MYHOST rsync backup log" $ADMINS
## 30.Jan.01 -- Art Mulder - strip the log file of all the filenames
#cat $LOG | sed -e "/^## /d" |  mail -s "$MYHOST rsync backup log" $ADMINS
/bin/cat $LOG | /usr/bin/mailx -s "Daily backup completed for localhost" $ADMINS

echo
echo "Removing old log file"
$RM $LOG

#
# End of Script
