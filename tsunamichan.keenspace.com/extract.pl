#!/usr/bin/perl
# $Id: extract.pl,v 1.3 2003-03-09 09:01:38 mitch Exp $
#
# $Log: extract.pl,v $
# Revision 1.3  2003-03-09 09:01:38  mitch
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
    last if $line =~ /<img.*alt=\"\".*src=\"\/comics\/$date.*<hr>/i;
}

# Wenn wir soweit sind, erzeugen wir wenigstens eine nicht-leere
# Datei, damit nicht bei jedem Durchlauf erneut versucht wird, einen
# Text zu finden
print " ";

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

