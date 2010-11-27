#!/usr/bin/perl -w

use strict;
use lib '..';
use Webcomic;

my $url = 'http://www.dominic-deegan.com/';
get_comics($url,
           {'a' => sub { my ($tag, $parser, $info) = @_;
                         if (tag_property($parser->get_tag('img'), 'alt', 'Previous')) {
                             $info->{'next'} = $url . $tag->[1]->{'href'};
                         }
                     },
            'div' => sub { my ($tag, $parser, $info) = @_;
                           if (tag_property($tag, 'class', 'comic')) {
                               $info->{'image'} = $parser->get_tag('img')->[1]->{'src'};
                               $info->{'filename'} = basename($info->{'image'});
                               if ($info->{'filename'} eq 'deegan2324.jpg') {
                                   $info->{'filename'} = '20100824.jpg'
                               }
                           }
                       },
           },
           \&file_exists);
