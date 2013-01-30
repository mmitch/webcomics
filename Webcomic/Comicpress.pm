package Webcomic::Comicpress;

use Any::Moose;

extends 'Webcomic';

has '+tags' => ( builder => '_tags' );

sub _tags {
    my $self = shift;
    return { 'div' => sub { my ($tag, $info) = @_;
                            if ($tag->has_property('id', 'comic')) {
                                $info->{'image'} = $tag->next_image();
                            } elsif ($tag->has_property('id', 'navbar') ||
                                     $tag->has_property('class', 'nav-previous')) {
                                $info->{'next'} = $tag->next_link();
                            }
                        },
             'a' => sub { my ($tag, $info) = @_;
                          if ($tag->has_property('class', 'navi-prev', 1)) {
                              $info->{'next'} = $tag->get_property('href');
                              unless ($info->{'next'} =~ /^http/) {
                                  $info->{'next'} = $self->url() . $info->{'next'};
                              }
                          }
                      }
           };
}

no Any::Moose;

__PACKAGE__->meta->make_immutable;
