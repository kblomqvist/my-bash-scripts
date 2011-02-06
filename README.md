Collection of Unix Scripts
==========================

do_update
- This script cascade aptitude update && aptitude safe-upgrade. The safe-upgrade is run in screen in case of abrupt termination of the ssh connection.
- Usage: do_update

mysqldumpgrep
- Takes mysqldump from user defined database tables matching with the regex pattern.
- Usage: mysqldumpgrep [MYSQL | MYSQLDUMP OPTIONS] DB_NAME PATTERN
- Example: mysqldumpgrep -p passwd mydb ^prefix_ > dump.sql
