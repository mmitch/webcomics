#!/usr/bin/perl
# $Id: extract.pl,v 1.6 2003-03-16 23:18:48 mitch Exp $
#
# $Log: extract.pl,v $
# Revision 1.6  2003-03-16 23:18:48  mitch
# Bugfix Liner's Notes
#
# Revision 1.5  2003/03/09 12:51:42  mitch
# Umgehung des Liner's Notes-Bugs in Anime_Parody #2
#
# Revision 1.4  2003/03/09 09:03:42  mitch
# Bugfix: nicht-leere Datei wurde auch bei im Fehlerfall angelegt
#
# Revision 1.3  2003/03/09 09:01:38  mitch
# Verhindern von ständigem erneuten Runterladen leerer Liner's Notes
#
# Revision 1.2  2003/03/08 14:18:28  mitch
# Funktioniert jetzt auch mit <P>s in den Liner's Notes.
# Überflüssige chomp()s entfernt.
#
# Revision 1.1  2003/03/07 21:30:01  mitch
# Neue Datei zum Extrahieren der Liner's Notes.
#

use strict;
use warnings;

my $date = shift;

die "no date given" unless defined $date;

# skip
while (my $line=<>) {
    if ($line =~ /<img.*alt=\"\".*src=\"[^\"]*\/comics\/$date\./i) {
	# Wenn wir das gefunden haben, erzeugen wir wenigstens eine nicht-leere
	# Datei, damit nicht bei jedem Durchlauf erneut versucht wird, einen
	# Text zu finden
	print " ";
	last;
    }
}


# skip
while (my $line=<>) {
    last if $line =~ /<\/center>/i;
}

# take
while (my $line=<>) {
    exit if $line =~ /^\s*<p>\s*$/i;
    exit if $line =~ /^\s*<center*s$>/i;
    print $line;
}

