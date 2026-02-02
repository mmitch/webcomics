#!/usr/bin/perl -w

use strict;
use lib '..';
use Webcomic;

my $comic = Webcomic->new(url => 'http://www.dumbingofage.com/');

$comic->tags({ 'div' => sub { my ($tag, $info) = @_;
			    if ($tag->has_property('id', 'comic')) {
                                $info->{'image'} = $tag->next_image();
                            } elsif ($tag->has_property('id', 'navbar') ||
                                     $tag->has_property('class', 'nav-previous')) {
                                $info->{'next'} = $tag->next_link();
                            }
                        },
             'a' => sub { my ($tag, $info) = @_;
                          if ($tag->has_property('class', 'navi-prev', 1)
			      or $tag->has_property('class', 'previous-comic', 1)) {
                              $info->{'next'} = $tag->get_property('href');
                              unless ($info->{'next'} =~ /^http/) {
                                  $info->{'next'} = $comic->url() . $info->{'next'};
                              }
                          }
                      },
	     });

$comic->update();
