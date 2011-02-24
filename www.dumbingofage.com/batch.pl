#!/usr/bin/perl -w

use strict;
use lib '..';
use Webcomic;

my $comic = Webcomic->new(url => 'http://www.dumbingofage.com/');

$comic->tags({ 'div' => sub { my ($tag, $info) = @_;
                              if ($tag->has_property('id', 'comic')) {
                                  $info->{'image'} = $tag->next_image();
                              }
                          },
               'a' => sub { my ($tag, $info) = @_;
                            if ($tag->has_property('class', 'navi-prev', 1)) {
                                $info->{'next'} = $tag->get_property('href');
                            }
                        }
             });

$comic->update();
