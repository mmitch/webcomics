#!/usr/bin/perl -w
#
# check for stalled comic scripts
#
# Copyright (C) 2009  Christian Garbs <mitch@cgarbs.de>
# licensed unter GNU PL v2 or later
#
use strict;

# whitelist
my %whitelist = map { $_ => $_ } qw(

COMIC
archive/1994/www.dilbert.com
archive/1995/www.dilbert.com
archive/1996/www.dilbert.com
archive/1997/www.dilbert.com
archive/1998/www.dilbert.com
archive/1999/www.dilbert.com
archive/2000/www.dilbert.com
archive/2001/www.dilbert.com
archive/2002/www.dilbert.com
archive/2003/www.dilbert.com
archive/2004/www.dilbert.com
archive/2004/www.penny-arcade.com
archive/2005/ChugworthAcademy
archive/2005/IrregularWebcomic
archive/2005/arlonjanis
archive/2005/www.ctrlaltdel-online.com
archive/2005/www.dilbert.com
archive/2005/www.errantstory.com
archive/2005/www.penny-arcade.com
archive/2005/www.userfriendly.org
archive/www.applegeeks.com
inverloch.seraph-inn.com
manga.clone-army.org
manga.clone-army.org/april_and_may
manga.clone-army.org/hh
manga.clone-army.org/june_in_summer
manga.clone-army.org/momoka_corner
manga.clone-army.org/paper_eleven
manga.clone-army.org/penny_tribute
tsunamichan.keenspace.com/anime_parody
tsunamichan.keenspace.com/experimental_comic_kotone
tsunamichan.keenspace.com/guest_strips
tsunamichan.keenspace.com/katwalk_studio
tsunamichan.keenspace.com/magical_mina
www.alpha-shade.com
www.exploitationnow.com
www.girlgeniusonline.com
www.machall.com
www.michael-fredrich.de
www.pbfcomics.com
www.queenofwands.net
www.ruthe.de
www.w00t-comic.net

);


# find comic directories
my @dirs;
open COMICS, 'find -name COMIC|' or die "can't spawn find: $!";
while (my $line = <COMICS>) {
    chomp $line;
    $line =~ s:^./::;
    $line =~ s:/COMIC::;
    push @dirs, $line unless exists $whitelist{$line};
}
close COMICS or die "can't close find: $!";


# check directories
my $time = time();
foreach my $dir (sort @dirs) {
    my $mtime = (stat( $dir.'/index' ))[9];
    my $days = int (($time - $mtime) / (60 * 60 * 24));
    printf "%3dd %s\n", $days, $dir if $days > 14;
}

