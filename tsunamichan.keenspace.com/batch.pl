#!/usr/bin/perl -w
# $Id: batch.pl,v 1.1 2003-03-06 19:04:00 mitch Exp $

# $Log: batch.pl,v $
# Revision 1.1  2003-03-06 19:04:00  mitch
# Initial source import.
# Kopierbasis: www.penny-arcade.com/batch.sh,v 1.1
#

use strict;

while (my $in = <>) {
    chomp $in;
    if ($in =~ m,^<LI><A HREF=\"d/(\d{8})\.html\">(.*)</A>$,) {
	printf "%s\n%s\n*-------*\n", $1, $2;
    }
}
