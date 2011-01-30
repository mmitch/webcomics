#!/usr/bin/perl -w

use strict;
use lib '..';
use Webcomic;

my $url = 'http://satwcomic.com/';
get_comics($url,
           {'a' => sub { my ($tag, $parser, $info) = @_;
                         if (tag_property($tag, 'accesskey', 'p')) {
                             $info->{'next'} = $tag->[1]->{'href'};
                         }
                     },
            'img' => sub { my ($tag, $parser, $info) = @_;
                           if (tag_property($tag, 'src', '/art/', 1)) {
                               $info->{'image'} = $tag->[1]->{'src'};
                               $info->{'filename'} = basename($info->{'image'});
                           }
                       },
            'div' => sub { my ($tag, $parser, $info) = @_;
                           if (tag_property($tag, 'class', 'comicdesc')) {
                               $parser->get_tag('small');
                               my ($d, $m, $y) = ($parser->get_text() =~ /(\d{1,2})\w+ (\d{1,2}) (\d{4})/);
                               my $date = sprintf("%d%02d%02d", $y, $m, $d);
                               $info->{'filename'} = "$date-" . $info->{'filename'};
                               $info->{'end'} = 1;
                           }
                       },
           },
           \&file_exists);
