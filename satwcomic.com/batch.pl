#!/usr/bin/perl -w

use strict;
use lib '..';
use Webcomic;

my $comic = Webcomic->new(url => 'http://satwcomic.com/');

$comic->tags({'a' => sub { my ($tag, $info) = @_;
                           if ($tag->has_property('accesskey', 'p')) {
                               $info->{'next'} = $tag->get_property('href');
                           }
                       },
              'img' => sub { my ($tag, $info) = @_;
                             if ($tag->has_property('src', '/art/', 1)) {
                                 $info->{'image'} = $tag->get_property('src');
                                 $info->{'filename'} = $comic->basename($info->{'image'});
                             }
                         },
              'div' => sub { my ($tag, $info) = @_;
                             if ($tag->has_property('class', 'comicdesc')) {
                                 $tag = $tag->next('small');
                                 my ($d, $m, $y) = ($tag->get_text() =~ /(\d{1,2})\w+ (\d{1,2}) (\d{4})/);
                                 my $date = sprintf("%d%02d%02d", $y, $m, $d);
                                 $info->{'filename'} = "$date-" . $info->{'filename'};
                                 $info->{'end'} = 1;
                             }
                         },
             });

$comic->update();
