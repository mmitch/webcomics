#!/usr/bin/perl -w

use strict;
use lib '..';
use Webcomic;

my $url = 'http://www.dorktower.com/';

get_comics($url,
           { 'a' => sub { my ($tag, $parser, $info) = @_;
                          if (tag_property($tag, 'title', '(DORK TOWER)|(Permanent Link)', 1)) {
                              my ($y, $m, $d) = ($tag->[1]->{'href'} =~ /(\d{4})\/(\d{2})\/(\d{2})/);
                              $info->{'date'} = "$y$m$d";
                          } elsif ($parser->get_text() eq '< - Previous') {
                              $info->{'next'} = $url . $tag->[1]->{'href'};
                          }
                      },
             'div' => sub { my ($tag, $parser, $info) = @_;
                            if (tag_property($tag, 'class', 'entry')) {
                                $info->{'image'} = $parser->get_tag('img')->[1]->{'src'};
                                unless ($info->{'image'} =~ /^http/) {
                                    $info->{'image'} = $url . $info->{'image'};
                                }
                                my ($orig) = ($info->{'image'} =~ /.*\/(.*)/);
                                $info->{'filename'} = $info->{'date'}."-$orig";
                                $info->{'end'} = 1;
                            }
                        }
           },
           sub { my %info = @_;
                 return (-e $info{'filename'} and ($info{'filename'} !~ /797|DTcartoon/))
             });
