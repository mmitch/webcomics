#!/usr/bin/perl -w

use strict;
use lib '..';
use Webcomic;

my $url = 'http://www.threepanelsoul.com/';
my %months = qw(January 01 February 02 March 03 April 04 May 05 June 06
                July 07 August 08 September 09 October 10 November 11 December 12);

sub parse_date {
    my $date = shift;
    my ($month, $day, $year) = ($date =~ /\w+, (\w+)\s+(\d+), (\d+)/);
    return $year . $months{$month} . sprintf('%02d', $day);
}

get_comics($url,
          { 'span' => sub { my ($tag, $parser, $info) = @_;
                            if (tag_property($tag, 'class', 'rss-id')) {
                                $info->{'date'} = parse_date($parser->get_text());
                            } elsif (tag_property($tag, 'class', 'rss-content')) {
                                $info->{'image'} = $parser->get_tag('img')->[1]->{'src'};
                                $info->{'filename'} = "$info->{'date'}-" . basename($info->{'image'});
                            }
                        },
            'a' => sub { my ($tag, $parser, $info) = @_;
                         if ($parser->get_text() eq 'previous') {
                             $info->{'next'} = $url . $tag->[1]->{'href'}
                         }
                     }
          },
          \&file_exists);
