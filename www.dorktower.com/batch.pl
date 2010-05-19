#!/usr/bin/perl -w

use strict;

use LWP::UserAgent;
use HTML::TokeParser;

my $url = 'http://www.dorktower.com/';
my $next = $url;
my $ua = LWP::UserAgent->new;
my $exitcode = 2;
my ($y, $m, $d);

while (1) {
    my $res = $ua->get($next);
    unless ($res->is_success) {
        die "Could not download URL $next.";
    }
    my $parser = HTML::TokeParser->new(\$res->decoded_content());
    while (my $tag = $parser->get_tag('div', 'a')) {
        if ($tag->[0] eq 'div') {
            if (defined($tag->[1]->{'class'})
                and $tag->[1]->{'class'} eq 'entry') {
                my $image = $parser->get_tag('img')->[1]->{'src'};
                unless ($image =~ /^http/) {
                    $image = $url . $image;
                }
                my ($orig) = ($image =~ /.*\/(.*)/);
                my $filename = "$y$m$d-$orig";
                if (-e $filename and ($filename !~ /797|DTcartoon/)) {
                    print "Finished.\n";
                    exit $exitcode;
                }
                $| = 1;
                print "fetching $filename: ";
                $res = $ua->mirror($image, $filename);
                if ($res->is_success()) {
                    print "ok\n";
                    $exitcode = 0;
                } else {
                    print "nok\n";
                }
                last;
            }
        } elsif ($tag->[0] eq 'a') {
            if (defined($tag->[1]->{'title'})
                and ($tag->[1]->{'title'} =~ /(DORK TOWER)|(Permanent Link)/)) {
                ($y, $m, $d) = ($tag->[1]->{'href'} =~ /(\d{4})\/(\d{2})\/(\d{2})/);
            } elsif ($parser->get_text() eq '< - Previous') {
                $next = $url . $tag->[1]->{'href'};
            }
        }
    }
}
