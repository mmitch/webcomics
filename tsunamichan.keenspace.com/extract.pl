#!/usr/bin/perl
# $Id: extract.pl,v 1.1 2003-03-07 21:30:01 mitch Exp $
#
# $Log: extract.pl,v $
# Revision 1.1  2003-03-07 21:30:01  mitch
# Neue Datei zum Extrahieren der Liner's Notes.
#

use strict;
use warnings;

my $date = shift;

die "no date given" unless defined $date;

# skip
while (my $line=<>) {
    chomp $line;
    last if $line =~ /<img.*alt=\"\".*src=\"\/comics\/$date.*<hr>/i;
}

# skip
while (my $line=<>) {
    chomp $line;
    last if $line =~ /<\/center>/i;
}

# take
while (my $line=<>) {
    exit if $line =~ /<p>/i;
    exit if $line =~ /<center>/i;
    print $line;
}

