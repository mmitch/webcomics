#!/usr/bin/perl -w

use strict;
use lib '..';
use Webcomic;

my $comic = Webcomic->new(url => 'http://www.spinnyverse.com/comic/');

$comic->tags({'a' => sub { my ($tag, $info) = @_;
                           if ($tag->has_property('class', 'prev')
			       and $tag->has_property('rel', 'prev')) {
                               $info->{'next'} = $tag->get_property('href');
                           }
                       },
              'img' => sub { my ($tag, $info) = @_;
                             if ($tag->has_property('id', 'cc-comic')) {
                                 $info->{'image'} = $tag->get_property('src');
                                 $info->{'filename'} = $comic->basename($info->{'image'});
                             }
                         },
             });

$comic->update();
