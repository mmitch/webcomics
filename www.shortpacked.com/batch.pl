#!/usr/bin/perl -w

use strict;
use lib '..';
use Webcomic;

my $url = 'http://shortpacked.com/';

get_comics($url,
           { 'div' => sub { my ($tag, $parser, $info) = @_;
                            if (tag_property($tag, 'id', 'comic')) {
                                $info->{'image'} = $parser->get_tag('img')->[1]->{'src'};
                                $info->{'filename'} = basename($info->{'image'});
                            }
                        },
             'a' => sub { my ($tag, $parser, $info) = @_;
                          if (tag_property($tag, 'class', 'navi-prev', 1)) {
                              $info->{'next'} = $tag->[1]->{'href'};
                          }
                      }
           },
          \&file_exists);
