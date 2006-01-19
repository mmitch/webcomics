#!/usr/bin/perl -w
# $Id: batch.pl,v 1.3 2006-01-19 19:13:17 mitch Exp $

use strict;

while (my $in = <>) {
    chomp $in;
    if ($in =~ m|^\s+(\d\d/\d\d/\d{4})\s(.*)$|) {
	printf "%s\n%s\n*-------*\n", $1, $2;
    }
}
