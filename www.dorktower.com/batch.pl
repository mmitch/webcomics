#!/usr/bin/perl -w

use strict;
use lib '..';
use Webcomic;

my $comic = Webcomic->new(url => 'http://www.dorktower.com/',
                          end => sub { my %info = @_;
                                       return (-e $info{'filename'} and ($info{'filename'} !~ /797|DTcartoon/))
                                   });

$comic->tags({ 'a' => sub { my ($tag, $info) = @_;
                            if ($tag->has_property('title', '(DORK TOWER)|(Permanent Link)', 1)) {
                                my ($y, $m, $d) = ($tag->get_property('href') =~ /(\d{4})\/(\d{2})\/(\d{2})/);
                                $info->{'date'} = "$y$m$d";
                            } elsif ($tag->get_text() eq '< - Previous') {
                                $info->{'next'} = $comic->url() . $tag->get_property('href');
                            }
                        },
               'div' => sub { my ($tag, $info) = @_;
                              if ($tag->has_property('class', 'entry')) {
                                  $info->{'image'} = $tag->next_image();
                                  unless ($info->{'image'} =~ /^http/) {
                                      $info->{'image'} = $comic->url() . $info->{'image'};
                                  }
                                  my ($orig) = ($info->{'image'} =~ /.*\/(.*)/);
                                  $info->{'filename'} = $info->{'date'}."-$orig";
                                  $info->{'end'} = 1;
                              }
                          }
             });

$comic->update();
