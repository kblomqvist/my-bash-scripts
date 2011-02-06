#!/bin/bash
# Takes mysqldump from user defined database tables matching with the
# regex pattern.
# 
# Usage: mysqldumpgrep [MYSQL | MYSQLDUMP OPTIONS] DB_NAME PATTERN
# Example: mysqldumpgrep -p passwd mydb ^prefix_ > dump.sql
#
# The MIT License
#
# Copyright (c) 2011 Kim Blomqvist
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
until [ -z "$3" ]
do
	OPTIONS="$OPTIONS $1"
	shift
done

if [ "$#" != 2 ]
then
	echo "Usage: $0 [MYSQL | MYSQLDUMP OPTIONS] DB_NAME PATTERN"
	exit 0
fi

TABLES=`mysql $OPTIONS -Bse 'show tables;' $1 | grep $2`
mysqldump $OPTIONS --skip-lock-tables $1 $TABLES

exit 0
