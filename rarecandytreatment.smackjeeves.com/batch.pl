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

my $url = 'http://rarecandytreatment.smackjeeves.com/';
get_comics($url,
           {'li' => sub { my ($tag, $parser, $info) = @_;
                         if (tag_property($tag, 'class', 'previous')) {
                             $info->{'next'} = $parser->get_tag('a')->[1]->{'href'};
                         }
                     },
            'img' => sub { my ($tag, $parser, $info) = @_;
			   if (tag_property($tag, 'id', 'comic_image')) {
                               $info->{'image'} = $tag->[1]->{'src'};
                               $info->{'filename'} = $info->{'date'} . '-' . basename($info->{'image'});
                           }
                       },
	    'h2' => sub { my ($tag, $parser, $info) = @_;
			  my $text = $parser->get_text();
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
	    'h1' => sub { my ($tag, $parser, $info) = @_;
			  $info->{'title'} = $parser->get_text(); ## what to do with this?  only first match per page is relevant!  store where?
                       },
           },
           \&file_exists);
