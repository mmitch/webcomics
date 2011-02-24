#!/usr/bin/perl -w

use strict;
use lib '..';
use Webcomic;

my %month = (
    'JAN' => '01',    'FEB' => '02',
    'MAR' => '03',    'APR' => '04',
    'MAY' => '05',    'JUN' => '06',
    'JUL' => '07',    'AUG' => '08',
    'SEP' => '09',    'OCT' => '10',
    'NOV' => '11',    'DEC' => '12'
);

my $comic = Webcomic->new(url => 'http://rarecandytreatment.smackjeeves.com/');

$comic->tags({'li' => sub { my ($tag, $info) = @_;
                            if ($tag->has_property('class', 'previous')) {
                                $info->{'next'} = $tag->next_link();
                            }
                        },
              'img' => sub { my ($tag, $info) = @_;
                             if ($tag->has_property('id', 'comic_image')) {
                                 $info->{'image'} = $tag->get_property('src');
                                 $info->{'filename'} = $info->{'date'} . '-' . $comic->basename($info->{'image'});
                                 my $titlefile = $info->{'filename'}.'.txt';
                                 open TITLE, '>', $titlefile or die "can't open `$titlefile': $!\n";
                                 print TITLE $info->{'title'}."\n";
                                 close TITLE or die "can't close `$titlefile': $!\n";
                             }
                         },
              'h2' => sub { my ($tag, $info) = @_;
                            my $text = $tag->get_text();
                            unless (exists $info->{'date'}) {
                                if ($text =~ /^(\d+)\s+(\w+)\s+(\d+)/) {
                                    if (exists $month{uc $2}) {
                                        $info->{'date'} = $3.$month{uc $2}.$1
                                    } else {
                                        die "unparseable date: `$text'\n";
                                    }
                                }
                            }
                        },
              'h1' => sub { my ($tag, $info) = @_;
                            unless (exists $info->{'title'}) {
                                $info->{'title'} = $tag->get_text();
                            }
                        },
             });

$comic->update();
