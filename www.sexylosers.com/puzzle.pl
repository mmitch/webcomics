#!/usr/bin/perl

# $Id: puzzle.pl,v 1.2 2002-12-22 22:00:21 mitch Exp $

# Dieses Programm "rendert" kleine HTML-Tabellen mit Bildern in ein
# grossen Bild.

# $Log: puzzle.pl,v $
# Revision 1.2  2002-12-22 22:00:21  mitch
# JPEG-Qualitaet erhoeht
#
# Revision 1.1  2002/12/22 21:41:14  mitch
# Initial revision
#

use warnings;
use strict;

use Image::Magick;
my $err; # Image::Magick errors

# read input and put each HTML tag onto a single line
my @lines;
while ( my $line = <> ) {
    chomp $line;
    $line =~ s/></>\n</g;
    push @lines, split /\n/, $line;
}

# get total width of picture
my $tw = 0; # total width
map { $tw = $1 if /<table.*width=(\d+).*>/i } @lines;

# create list of images with finemale, heigth and width
my @img; # images
foreach ( @lines ) {
    if ( /<img.*src=\"([^\"]+)\".*height=(\d+).*width=(\d+).*>/i ) {
	my $img = Image::Magick->new; 
	$err = $img->Read($1);
	warn $err if $err;
#	print $img->Get('colors')."\n";
	push @img, {
	    FILE => $1,
	    IMG => $img,
	    H => $2,
	    W => $3,
	};
    }
}
	
# create a cursor, walk over images and determine position
my $cx = 0; # cursor X
my $cy = 0; # cursor Y
my $lh = 0; # last heigth
my $th = 0; # total heigth
foreach my $img (@img) {
    if ( $cx + $img->{W} > $tw) {
	$th += $lh;
	$cy += $lh;
	$cx = 0;
    }
    $lh = $img->{H};
    $img->{X} = $cx;
    $img->{Y} = $cy;
    $cx += $img->{W};
}
$th += $lh;

# print position of all images
#foreach my $img (@img) {
#    print "$img->{FILE}: $img->{W}x$img->{H}+$img->{X}+$img->{Y}\n";
#}
#print "total: ${tw}x${th}\n";

# combine image
my $image = Image::Magick->new;
$err = $image->Set(size=>"${tw}x${th}");
warn $err if $err;
$err = $image->Set(quality=>100);
warn $err if $err;
$err = $image->ReadImage('xc:black');
warn $err if $err;

foreach my $img (@img) {
    $err = $image->Composite(image=>$img->{IMG}, compose=>'Over', geometry=>"$img->{W}x$img->{H}+$img->{X}+$img->{Y}");
    warn $err if $err;
}
$err = $image->Write('converted.jpg');
warn $err if $err;
