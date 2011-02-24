#!/usr/bin/perl -w

use strict;
use lib '..';
use Webcomic;

my $comic = Webcomic->new(url => 'http://www.threepanelsoul.com/');

$comic->tags({ 'div' => sub { my ($tag, $info) = @_;
                              if ($tag->has_property('id', 'comic')) {
                                  $info->{'image'} = $tag->next_image();
                              } elsif ($tag->has_property('class', 'nav-previous')) {
                                  $info->{'next'} = $tag->next_link();
                              }
                          },
             });

$comic->update();
