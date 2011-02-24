package Tag;

use Any::Moose;

has 'tag' => ( is => 'ro',
               required => 1 );

has 'parser' => ( is => 'ro',
                  required => 1 );

sub has_property {
    my ($self, $property, $value, $contains) = @_;
    if (defined($self->tag()->[1]->{$property})) {
        if (defined($contains)) {
            return ($self->tag()->[1]->{$property} =~ /$value/);
        } else {
            return ($self->tag()->[1]->{$property} eq $value);
        }
    } else {
        return 0;
    }
}

sub get_property {
    my ($self, $property) = @_;
    return $self->tag()->[1]->{$property};
}

sub next {
    my ($self, $tag) = @_;
    return Tag->new(tag => $self->parser()->get_tag($tag),
                    parser => $self->parser());
}

sub get_text {
    my $self = shift;
    $self->parser()->get_text();
}

sub next_image {
    my $self = shift;
    return $self->parser()->get_tag('img')->[1]->{'src'};
}

sub next_link {
    my $self = shift;
    return $self->parser()->get_tag('a')->[1]->{'href'};
}

no Any::Moose;

__PACKAGE__->meta->make_immutable;
