#!/bin/sh
#
# Backuping
# ---------
# dups3 backup
#
# Restoring
# ---------
# dups3 restore /home/my/foo.txt ~/restore		  # Restore a file
# dups3 restore /home/my ~/restore				  # Restore a directory
#
# todo:
# dups3 restore -t 2010-09-22T01:10:00 ~/restore  # Restore everything from a point in time
#
# References
# ----------
# [1] (http://icelab.com.au/articles/easy-server-backups-to-amazon-s3-with-duplicity/)
#
 
# ---------------------------------------------------------------------
# Settings
# ---------------------------------------------------------------------

# Note that underscores '_' are not allowed in EU bucket names.
DEST=s3+http://your.s3.bucket

# Export some ENV variables so you don't have to type anything
export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET_ACCESS_KEY
export PASSPHRASE=YOUR_PASSPHRASE

GPG_KEY=YOUR_GPG_KEY

# ---------------------------------------------------------------------
# Program starts here
# ---------------------------------------------------------------------
if [ "$#" -eq 1 ] && [ $1 = "backup" ]; then
	duplicity \
		--s3-use-new-style \
		--encrypt-key=${GPG_KEY} \
		--sign-key=${GPG_KEY} \
		--include=/home \
		--include=/etc \
		--exclude=/** \
		--full-if-older-than 30D \
		/ ${DEST}

	duplicity remove-older-than 6M --force ${DEST}
elif [ "$#" -eq 3 ] && [ $1 = "restore" ]; then
	duplicity --file-to-restore $2 ${DEST} $3
else
	echo "Usage:"
	echo "	dups3 backup							  # Run backups"
	echo "	dups3 restore /home/my/foo.txt ~/restore  # Restore a file"
	echo "	dups3 restore /home/my ~/restore		  # Restore a directory"
fi

# Reset the ENV variables. Don't need them sitting around
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export PASSPHRASE=

exit 0
