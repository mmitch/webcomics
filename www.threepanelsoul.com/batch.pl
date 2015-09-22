#!/usr/bin/perl -w

use strict;
use lib '..';
use Webcomic;

my $comic = Webcomic->new(url => 'http://www.threepanelsoul.com/');

$comic->tags({
    'div' => sub { my ($tag, $info) = @_;
		   if ($tag->has_property('id', 'cc-comicbody')) {
		       $info->{'image'} = $tag->next_image();
		   } elsif ($tag->has_property('id', 'nav') ||
			    $tag->has_property('class', 'prev')) {
		       $info->{'next'} = $tag->next_link();
		   }
    },
    'a' => sub { my ($tag, $info) = @_;
		 if ($tag->has_property('class', 'prev', 1)) {
		     $info->{'next'} = $tag->get_property('href');
		     unless ($info->{'next'} =~ /^http/) {
			 $info->{'next'} = $comic->url() . $info->{'next'};
		     }
		 }
    }
	     });

$comic->update();
