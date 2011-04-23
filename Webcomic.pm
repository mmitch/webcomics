package Webcomic;

use Any::Moose;
use Webcomic::Tag;
use Cwd;
use LWP::UserAgent;
use HTML::TokeParser;

has 'url' => ( is => 'ro',
               isa => 'Str',
               required => 1 );

has 'tags' => ( is => 'rw',
                isa => 'HashRef[CodeRef]' );

has 'end' => ( is => 'ro',
               isa => 'CodeRef',
               default => sub { \&_file_exists } );

sub _download {
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

sub update {
    my $self = shift;
    my $next = $self->url();
    my $exitcode = 2;
    my $ua = LWP::UserAgent->new('agent' => 'Firefox');
    my $tags = $self->tags();
    while (1) {
        my %info = ();
        my $res = $ua->get($next);
        unless ($res->is_success) {
            die "Could not download URL $next: ", $res->status_line, ".\n";
        }
        my $parser = HTML::TokeParser->new(\$res->decoded_content());
        while (my $tag = $parser->get_tag(keys %$tags)) {
            $self->tags()->{$tag->[0]}->(Webcomic::Tag->new(tag => $tag, parser => $parser), \%info);
            last if ($info{'end'});
        }
        unless (defined $info{'filename'}) {
            $info{'filename'} = $self->basename($info{'image'});
        }
        if ($self->end()->(%info)) {
            print "Finished.\n";
            exit $exitcode;
        }
        _download(\%info, $ua, \$exitcode);
        $next = $info{'next'};
    }
}

sub _file_exists {
    my %info = @_;
    die cwd unless exists $info{'filename'};
    return (-e $info{'filename'});
}

sub basename {
    my ($self, $image) = @_;
    return (split(/.*\//, $image))[1];
}

no Any::Moose;

__PACKAGE__->meta->make_immutable;
