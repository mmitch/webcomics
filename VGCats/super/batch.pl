#!/usr/bin/perl -w

use strict;
use lib '../..';
use Webcomic;

my $url = 'http://www.vgcats.com/super/';

get_comics($url,
           { 'td' => sub { my ($tag, $parser, $info) = @_;
                            if (tag_property($tag, 'background', 'siteimages/comicbg.gif')) {
                                $info->{'image'} = $url . $parser->get_tag('img')->[1]->{'src'};
                                $info->{'filename'} = basename($info->{'image'});
                            }
                        },
             'table' => sub { my ($tag, $parser, $info) = @_;
                          if (tag_property($tag, 'width', '518')) {
                              $info->{'next'} = $url . $parser->get_tag('a')->[1]->{'href'};
                          }
                      }
           },
          \&file_exists);
