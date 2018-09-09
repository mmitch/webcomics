#!/usr/bin/perl -w
#
# check for stalled comic scripts
#
# Copyright (C) 2009  Christian Garbs <mitch@cgarbs.de>
# licensed unter GNU GPL v2 or later
#
use strict;

# whitelist
my %whitelist = map { $_ => $_ } qw(

BetterDays
COMIC
ComicsDotCom/arlonjanis
DominicDeegan
Drowtales
Flipside
IrregularWebcomic
KeenSpot/Ghastly
KeenSpot/RaveKitty
KeenSpot/SinFest
KeenSpot/TwoLumps
Nodwick
RealLife
SequentialArt
SnafuComics/GrimTales
SnafuComics/PowerPuffGirls
Sokora
UClick/BC
VGButts
VGCats/super
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
archive/2009/Flipside
archive/2009/IrregularWebcomic
archive/2009/KeenSpot/CountYourSheep
archive/2009/KeenSpot/Lounge
archive/2009/KeenSpot/SinFest
archive/2009/KeenSpot/TwoLumps
archive/2009/Nodwick
archive/2009/QuestionableContent
archive/2009/SequentialArt
archive/2009/requiem.seraphim-inn.com
archive/2009/www.ctrlaltdel-online.com
archive/2009/www.dilbert.com
archive/2009/www.errantstory.com
archive/2009/www.girlgeniusonline.com/AdvancedClass
archive/2009/www.megatokyo.com
archive/2009/www.misfile.com
archive/2009/www.nichtlustig.de
archive/2009/www.penny-arcade.com
archive/2009/www.sakurai-cartoons.de
archive/2009/www.shortpacked.com
archive/2009/www.thedevilspanties.com
archive/2009/www.userfriendly.org
archive/2009/xkcd
archive/2009/yafgc.shipsinker.com
archive/2010/www.legostargalactica.net
archive/2010/www.pvponline.com
archive/IrregularWebcomic
archive/www.applegeeks.com
digitalunrestcomic.com
inverloch.seraph-inn.com
manga.clone-army.org
manga.clone-army.org/april_and_may
manga.clone-army.org/hh
manga.clone-army.org/june_in_summer
manga.clone-army.org/momoka_corner
manga.clone-army.org/nana
manga.clone-army.org/paper_eleven
manga.clone-army.org/penny_tribute
requiem.seraph-inn.com
satwcomic.com
tsunamichan.keenspace.com/anime_parody
tsunamichan.keenspace.com/experimental_comic_kotone
tsunamichan.keenspace.com/guest_strips
tsunamichan.keenspace.com/katwalk_studio
tsunamichan.keenspace.com/magical_mina
woweh.com
www.alpha-shade.com
www.applegeeks.com
www.applegeeks.com/lite
www.dorktower.com
www.exploitationnow.com
www.giantitp.com/erfworld
www.giantitp.com/oots
www.girlgeniusonline.com
www.jaynaylor.com/originallife
www.machall.com
www.mezzacotta.net/garfield
www.michael-fredrich.de
www.mimisgrotto.com/thorn
www.misfile.com
www.nichtlustig.de
www.pbfcomics.com
www.pvponline.com
www.queenofwands.net
www.ruthe.de
www.shortpacked.com
www.upevil.com
www.userfriendly.org
www.w00t-comic.net
yafgc.shipsinker.com
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
close COMICS;


# check directories
my $time = time();
foreach my $dir (sort @dirs) {
    my $mtime = (stat( $dir.'/index' ))[9];
    my $days = int (($time - $mtime) / (60 * 60 * 24));
    printf "%3dd %s\n", $days, $dir if $days > 14;
}

