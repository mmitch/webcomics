#!/usr/bin/perl -w
# $Id: batch.pl,v 1.1 2003-02-12 00:41:55 ikari Exp $

# $Log: batch.pl,v $
# Revision 1.1  2003-02-12 00:41:55  ikari
# Kopierquelle: Megatokyo-Script Revision 1.2
#
# Revision 1.2  2002/01/25 15:43:59  mitch
# Adapted to new Freshmeat page
#
# Revision 1.1  2001/10/20 19:01:36  mitch
# Initial revision
#

use strict;

while (my $in = <>) {
    chomp $in;
    if ($in =~ /^<option value=\"(.*)date=(.*)\">(\d\d\/\d\d\/\d{4})  (.*)$/) {
	printf "%s\n%s\n*-------*\n", $2, $4;
    }
}
