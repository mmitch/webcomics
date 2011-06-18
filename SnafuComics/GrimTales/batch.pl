#!/usr/bin/perl -w

use strict;
use lib '../..';
use Webcomic;

my $comic = Webcomic->new(url => 'http://grim.snafu-comics.com/');

$comic->tags({ 'img' => sub { my ($tag, $info) = @_;
                              if ($tag->get_property('src') =~ m!/comics/!) {
                                  $info->{'image'} = $tag->get_property('src');
                                  ($info->{'filename'} = $comic->basename($info->{'image'})) =~ s/_ppg//;
                                  $info->{'filename'} =~ s/\.jpg$/.jpeg/;
                              }
                          },
               'a' => sub { my ($tag, $info) = @_;
                            if ($tag->get_text() eq 'Previous') {
                                $info->{'next'} = $comic->url() . $tag->get_property('href');
                            }
                        }
             });

$comic->update();
