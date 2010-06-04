package Webcomic;

use warnings;
use strict;

use LWP::UserAgent;
use HTML::TokeParser;

BEGIN {
    use Exporter   ();
    our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);

    $VERSION     = 1.00;

    @ISA         = qw(Exporter);
    @EXPORT      = qw(&get_comics &file_exists &tag_property &basename);
    %EXPORT_TAGS = ( );

    @EXPORT_OK   = qw();
}
our @EXPORT_OK;

sub download {
    my ($info, $ua, $exitcode) = @_;
    $| = 1;
    print "fetching $info->{'filename'}: ";
    my $res = $ua->mirror($info->{'image'}, $info->{'filename'});
    if ($res->is_success()) {
        print "ok\n";
        ${$exitcode} = 0;
    } else {
        print "nok\n";
    }
}

sub get_comics {
    my ($next, $tags, $end) = @_;
    my $exitcode = 2;
    my $ua = LWP::UserAgent->new;
    my %info;
    while (1) {
        my $res = $ua->get($next);
        unless ($res->is_success) {
            die "Could not download URL $next: ", $res->status_line, ".\n";
        }
        my $parser = HTML::TokeParser->new(\$res->decoded_content());
        while (my $tag = $parser->get_tag(keys %$tags)) {
            $tags->{$tag->[0]}->($tag, $parser, \%info, $ua);
            last if ($info{'end'});
        }
        $info{'end'} = 0;
        if ($end->(%info)) {
            print "Finished.\n";
            exit $exitcode;
        }
        download(\%info, $ua, \$exitcode);
        $next = $info{'next'};
    }
}

sub tag_property {
    my ($tag, $property, $value, $contains) = @_;
    if (defined($tag->[1]->{$property})) {
        if (defined($contains)) {
            return ($tag->[1]->{$property} =~ /$value/);
        } else {
            return ($tag->[1]->{$property} eq $value);
        }
    } else {
        return 0;
    }
}


sub file_exists {
    my %info = @_;
    return (-e $info{'filename'});
}

sub basename {
    my $image = shift;
    return (split(/.*\//, $image))[1];
}

END { }

1;
