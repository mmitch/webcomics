#!/usr/bin/perl -w

use strict;
use lib '..';
use Webcomic;

my $comic = Webcomic->new(url => 'http://www.pvponline.com/');

$comic->tags({ 'div' => sub { my ($tag, $info) = @_;
                              if ($tag->has_property('id', 'comic')) {
                                  $info->{'image'} = $tag->next_image();
                              } elsif ($tag->has_property('id', 'navbar')) {
                                  $info->{'next'} = $tag->next_link();
                              }
                          }
             });

$comic->update();
