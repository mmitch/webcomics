#!/usr/bin/perl -w

use strict;

use LWP::UserAgent;
use HTML::TokeParser;

my $url = 'http://shortpacked.com/';
my $next = $url;
my $ua = LWP::UserAgent->new;

while (1) {
    my $res = $ua->get($next);
    unless ($res->is_success) {
        die "Could not download URL $next.";
    }
    my $parser = HTML::TokeParser->new(\$res->decoded_content());
    while (my $tag = $parser->get_tag('div', 'a')) {
        if ($tag->[0] eq 'div') {
            if (defined ($tag->[1]->{'id'}) and $tag->[1]->{'id'} eq 'comic') {
                my $image = $parser->get_tag('img')->[1]->{'src'};
                my $filename = (split(/.*\//, $image))[1];
                if (-e $filename) {
                    print "Finished.\n";
                    exit 0;
                }
                print "fetching $filename: ";
                $res = $ua->mirror($image, $filename);
                if ($res->is_success) {
                    print "ok\n";
                } else {
                    print "nok\n";
                }
            }
        } elsif ($tag->[0] eq 'a') {
            if (defined ($tag->[1]->{'class'}) and ($tag->[1]->{'class'} =~ /navi-prev/)) {
                $next = $tag->[1]->{'href'};
            }
        }
    }
}
