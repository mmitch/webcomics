#!/usr/bin/perl -w
# $Id: batch.pl,v 1.1 2001-10-20 19:01:36 mitch Exp $

# $Log: batch.pl,v $
# Revision 1.1  2001-10-20 19:01:36  mitch
# Initial revision
#

use strict;
while (my $in = <>) {
    chomp $in;
    if ($in =~ /^<option value='(\d+)'>(\d{4}-\d\d-\d\d) \[(\d+)\] (.*)$/) {
	printf "%s\n%s\n%03d\n%s\n*-------*\n", $1, $2, $3, $4;
    }
}