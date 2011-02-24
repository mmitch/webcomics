#!/usr/bin/perl -w

use strict;
use lib '..';
use Webcomic;

my $comic = Webcomic->new(url => 'http://www.dominic-deegan.com/');

$comic->tags({'a' => sub { my ($tag, $info) = @_;
                           if ($tag->next('img')->has_property('alt', 'Previous')) {
                               $info->{'next'} = $comic->url() . $tag->get_property('href');
                           }
                       },
              'div' => sub { my ($tag, $info) = @_;
                             if ($tag->has_property('class', 'comic')) {
                                 $info->{'image'} =  $comic->url() . $tag->next_image();
                                 $info->{'filename'} = $comic->basename($info->{'image'});
                                 if ($info->{'filename'} eq 'deegan2324.jpg') {
                                     $info->{'filename'} = '20100824.jpg'
                                 }
                             }
                         },
             });

$comic->update();
