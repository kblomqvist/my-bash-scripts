#!/bin/bash
# This script cascades aptitude update && aptitude safe-upgrade. The safe-
# upgrade is run in screen in case of abrupt termination of the ssh
# connection.
#
# Usage: safe-upgrade
#
sudo aptitude update
sudo screen -S update aptitude safe-upgrade
