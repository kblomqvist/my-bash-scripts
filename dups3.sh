#!/bin/sh
#
# Backuping
# ---------
# dups3 backup
#
# Restoring
# ---------
# dups3 restore /home/my/foo.txt ~/restore  # Restore a file
# dups3 restore /home/my ~/restore          # Restore a directory
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

# Amazon S3 bucket name and folder if any, for example 'mybucket'
# or 'mybucket/backups'
BUCKET=

# Amazon AWS key id and secret key
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

# Your GPG key which to use
GPG_KEY=

# Your GPG passphrase for the key defined above
export PASSPHRASE=

# MySQL access parameters. Be sure that you have MySQL privilege
# 'LOCK TABLES', otherwise database backup won't work.
#
# How to give 'LOCK TABLES' privilege for root:
#   GRANT LOCK TABLES ON *.* TO 'root'@'localhost';
#
MYSQL_DB_USER=
MYSQL_DB_PASSWORD=
MYSQL_DB_HOST=localhost

# Destination where to store MySQL dump file. The file will be named
# as 'mysqldump.sql'.
MYSQL_DUMP_DEST_DIR=/var/dbdumps

# ---------------------------------------------------------------------
# Program starts here
# ---------------------------------------------------------------------

if [ "$#" -eq 1 ] && [ $1 = "backup" ]; then

	# Prepare MySQL dump
	MYSQL_ACCESS_PARAMS="-h $MYSQL_DB_HOST -u $MYSQL_DB_USER \
		-p$MYSQL_DB_PASSWORD"

	MYSQL_DUMP_FILE="$MYSQL_DUMP_DEST_DIR/mysqldump.sql"

	mkdir -p $MYSQL_DUMP_DEST_DIR
	mysqldump $MYSQL_ACCESS_PARAMS --all-databases > $MYSQL_DUMP_FILE \
		&& chmod 600 $MYSQL_DUMP_FILE

	# Run backups
	duplicity \
		--s3-use-new-style \
		--encrypt-key=${GPG_KEY} \
		--sign-key=${GPG_KEY} \
		--full-if-older-than 30D \
		--include=/home \
		--include=/etc \
		--include=${MYSQL_DUMP_DEST_DIR} \
		--exclude="**" / s3+http://${BUCKET}

	# Remove backups which are older than 6 month
	duplicity remove-older-than 6M --force s3+http://${BUCKET}

elif [ "$#" -eq 3 ] && [ $1 = "restore" ]; then
	duplicity --file-to-restore $2 s3+http://${BUCKET} $3
else
	echo "Usage:"
	echo "	dups3 backup                              # Run backups"
	echo "	dups3 restore /home/my/foo.txt ~/restore  # Restore a file"
	echo "	dups3 restore /home/my ~/restore          # Restore a directory"
fi

# Reset the ENV variables. Don't need them sitting around
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export PASSPHRASE=

exit 0
