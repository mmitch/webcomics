#!/usr/bin/perl -w
# $Id: batch.pl,v 1.3 2003-03-06 19:30:04 mitch Exp $

# $Log: batch.pl,v $
# Revision 1.3  2003-03-06 19:30:04  mitch
# Anpassungen f�r die Kapitelnummern von Magical Mina
#
# Revision 1.2  2003/03/06 19:24:11  mitch
# Umgehen von Fehlern im Aufbar der Index-Seiten
#
# Revision 1.1  2003/03/06 19:04:00  mitch
# Initial source import.
# Kopierbasis: www.penny-arcade.com/batch.sh,v 1.1
#

use strict;

while (my $in = <>) {
    chomp $in;
    if ( $in =~ m/^<li>.*<a href=\"\/?d\/(\d{8})\.html\">(.*)<\/a>$/i ) {
	printf "%s\n%s\n*-------*\n", $1, $2;
    }
}
