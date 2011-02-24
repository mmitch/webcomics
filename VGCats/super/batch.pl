#!/usr/bin/perl -w

use strict;
use lib '../..';
use Webcomic;

my $comic = Webcomic->new(url => 'http://www.vgcats.com/super/');

$comic->tags({ 'td' => sub { my ($tag, $info) = @_;
                             if ($tag->has_property('background', 'siteimages/comicbg.gif')) {
                                 $info->{'image'} = $comic->url() . $tag->next_image();
                             }
                         },
               'table' => sub { my ($tag, $info) = @_;
                                if ($tag->has_property('width', '518')) {
                                    $info->{'next'} = $comic->url() . $tag->next_link();
                                }
                            }
             });

$comic->update();
