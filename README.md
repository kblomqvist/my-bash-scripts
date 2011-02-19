My scripts
==========

__safe-upgrade__

- This script cascades aptitude update && aptitude safe-upgrade. The safe-upgrade is run in screen in case of abrupt termination of the ssh connection.
- Usage: safe-upgrade

__mysqldumpgrep__

- Takes mysqldump from user defined database tables matching with the regex pattern.
- Example: mysqldumpgrep -p passwd mydb ^prefix_ > dump.sql
