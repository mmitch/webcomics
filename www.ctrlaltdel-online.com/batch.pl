#!/usr/bin/perl -w

# broken because of new JavaScript navigation
exit -1;

__DATA__

use strict;
use lib '..';
use Webcomic;

my $baseurl = 'http://www.cad-comic.com';
my $comic = Webcomic->new(url => 'http://www.cad-comic.com/cad/');

$comic->tags({ 'div' => sub { my ($tag, $info) = @_;
                              if ($tag->has_property('class', 'navigation')) {
                                  unless (defined ($info->{'image'})) {
                                      $info->{'image'} = $tag->next_image();
                                      $info->{'filename'} = $info->{'image'};
                                      $info->{'filename'} =~ s/.*(\d{4}\d{2}\d{2}).*(\.\w{3})/$1$2/;
                                  }
                              }
                          },
               'a' => sub { my ($tag, $info) = @_;
                            if ($tag->has_property('class', 'nav-back')) {
                                $info->{'next'} = $baseurl  . $tag->get_property('href');
                            }
                        }
             });

$comic->update();
