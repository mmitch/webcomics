#!/usr/bin/perl

# $Id: puzzle.pl,v 1.4 2003-01-11 18:36:06 mitch Exp $

# Dieses Programm "rendert" kleine HTML-Tabellen mit Bildern in ein
# grossen Bild.

# $Log: puzzle.pl,v $
# Revision 1.4  2003-01-11 18:36:06  mitch
# Komplett neue HTML-Engine, kommt mit allen Strips klar (auch #169)
#
# Revision 1.3  2002/12/22 22:07:24  mitch
# Erkennt alle bis jetzt erschienenen Varianten ohne Fehler.
#
# Revision 1.2  2002/12/22 22:00:21  mitch
# JPEG-Qualitaet erhoeht
#
# Revision 1.1  2002/12/22 21:41:14  mitch
# Initial revision
#

use warnings;
use strict;

my $debug = 0;
sub debug(@)
{
    print "@_" if $debug;
}

use Image::Magick;
my $err; # Image::Magick errors

# read input and put each HTML tag onto a single line
my @lines;
while ( my $line = <> ) {
    chomp $line;
    $line =~ s/></>\n</g;
    push @lines, split /\n/, $line;
}


my @img; # images

my $table = {};
my ($cx, $cy) = (0, 0); # cell cursor
my ($gx, $gy) = (0, 0); # graphic cursor
my ($cw, $ch) = (0, 0); # cell format
my ($gw, $gh) = (0, 0); # graphic format
my ($mh)      = 0;
my ($rows, $cols);

my @work = @lines;
while (my $line = shift @work) {

    # skip cells occupied by colspan/rowspan
    while (exists $table->{$cx}->{$cy}) {
	$gx += $table->{$cx}->{$cy}->{WIDTH};
	$cx ++;
    }

    if ($line =~ m:<TR>:i) {
	debug "row start\n";
    } elsif ($line =~ m:</TR>:i) {
	debug "row end\n";
	$cy ++;
	$gy += $mh;
	$cw = $cx if ($cx > $cw);
	$cx = 0;
	$gx = 0;
    } elsif ($line =~ m:<TD.*>:i) {

	# get cell data
	debug "cell start";
	($rows, $cols) = (1, 1);
	if ( $line =~ /rowspan\s*=\s*(\d+)/i ) {
	    $rows = $1;
	    debug ", rows=$1";
	}
	if ( $line =~ /colspan\s*=\s*(\d+)/i ) {
	    $cols = $1;
	    debug ", cols=$1";
	}
	debug "\n";

	# get image data
	my ($img, $src);
	while ($img = shift @work) {
	    last if $img =~ /<img\s+src/i;
	}

	debug "img:";
	my ($w, $h) = (0, 0);
	if ($img =~ /src\s*=\s*\"([^\"]+)\"/i) {
	    $src = Image::Magick->new; 
	    $err = $src->Read($1);
	    warn $err if $err;
	}
	if ($img =~ /width\s*=\s*(\d+)/i) {
	    $w = $1;
	    debug " width=$1";
	}
	if ($img =~ /height\s*=\s*(\d+)/i) {
	    $h = $1;
	    debug " height=$1";
	    if ($rows == 1) {
		$mh = $1;
	    }
	}
	debug "\n";

	# save image
	push @img, {
	    FILE => $1,
	    IMG => $src,
	    H => $h,
	    W => $w,
	    X => $gx,
	    Y => $gy
	};

	# picture format
	if ($gx + $w > $gw) {
	    $gw = $gx + $w;
	}
	if ($gy + $h > $gh) {
	    $gh = $gy + $h;
	}

	# reserve cells
	my ($x, $y);
	for ($x = $cx; $x < $cx+$cols; $x++) {
	    for ($y = $cy; $y < $cy+$rows; $y++) {
		$table->{$x}->{$y} = {
		    "WIDTH"  => $w,
		    "HEIGHT" => $h
		};
		debug ".";
	    }
	}

    } elsif ($line =~ m:</TD>:i) {
	debug "cell end\n";
    }
}
$ch = $cy;



debug "$cw x $ch cells\n";
foreach my $img (@img) {
    debug "$img->{FILE}: $img->{W}x$img->{H}+$img->{X}+$img->{Y}\n";
}
debug "total: ${gw}x${gh}\n";

# combine image
my $image = Image::Magick->new;
$err = $image->Set(size=>"${gw}x${gh}");
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
