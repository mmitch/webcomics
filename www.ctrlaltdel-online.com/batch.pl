#!/usr/bin/perl -w

use strict;
use lib '..';
use Webcomic;

my $baseurl = 'http://www.cad-comic.com';
my $comicurl = 'http://www.cad-comic.com/cad/';

get_comics($comicurl,
           { 'title' => sub { my ($tag, $parser, $info) = @_;
                              my ($y, $m, $d) = ($parser->get_text() =~ /\((\d{4})-(\d{2})-(\d{2})\)/);
                              $info->{'date'} = "$y$m$d";
                          },
             'div' => sub { my ($tag, $parser, $info) = @_;
                            if (tag_property($tag, 'class', 'navigation')) {
                                unless (defined ($info->{'image'})) {
                                    $info->{'image'} = $parser->get_tag('img')->[1]->{'src'};
                                    $info->{'filename'} = $info->{'date'} . "." . (split(/.*\./, $info->{'image'}))[1];
                                }
                            }
                        },
             'a' => sub { my ($tag, $parser, $info) = @_;
                          if (tag_property($tag, 'class', 'nav-back')) {
                              $info->{'next'} = $baseurl  . $tag->[1]->{'href'};
                          }
                      }
           },
           \&file_exists);
