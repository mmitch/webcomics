#!/usr/bin/perl -w

use strict;
use lib '..';
use Webcomic::Comicpress;

my $comic = Webcomic::Comicpress->new(url => 'http://www.thedevilspanties.com/');

$comic->update();
