package Hash::Weighted::Categorize;

# code eval'ed by Hash::Weighted::Categorize
# will have none of the extras lexically provided by Moo
sub __eval { eval shift }

use Moo;

use Hash::Weighted::Categorize::Parser;

has _parser => (
    is      => 'lazy',
);

sub _build__parser {
    my ($self) = @_;
    return Hash::Weighted::Categorize::Parser->new();
}

sub parse_to_source {
    my ($self, $input) = @_;
    $self->_parser->input( $input );
    return $self->_parser->Run;
}

sub parse {
    my ($self, $input) = @_;
    return __eval $self->parse_to_source($input);
}

1;

__END__

# ABSTRACT: Categorize weighted hashes using a Domain Specific Language

=head1 SYNOPSIS

    # create a parser
    my $parser = Hash::Weighted::Categorize->new(
        input   => [qw( OK WARN CRIT UNKN )],
        default => 'OK',
        strict => 1,    # die when the hash contains unknown status names
    );

    # generate a scoring function
    my $score = $parser->parse( << 'CODE' );
    %OK > 90%, %CRIT < .1: OK;
    %CRIT > 50%: CRIT;
    %CRIT > 25%: WARN;
    UNKN;
    CODE

    # OK
    $status = $score->( { OK => 19, CRIT => 2 } );

    # WARN
    $status = $score->( { OK => 14, CRIT => 6, WARN => 1 } );

    # CRIT
    $status = $score->( { OK => 8, CRIT => 11, WARN => 1, UNKN => 1 } );

    # UNKN
    $status = $score->( { OK => 18, CRIT => 2, WARN => 1 } );

=head1 DESCRIPTION

Hash::Weighted::Categorize is a tool to easily create scoring functions (think monitoring)
based on a simple mini-language. A Hash::Weighted::Categorize object is a parser for this
mini-language, that will return coderefs implementing a scoring function
written in this language.

=head1 METHODS

=head2 new()

Create a new L<Hash::Weighted::Categorize> object.

=head2 parse( $code )

Parse the content of C<$code> and return the corresponding code reference.

=head2 parse_to_source( $code )

Parse the content of C<$code> and return the Perl source code for the
code reference that would be returned by C<parse()>.

=head1 DOMAIN SPECIFIC LANGUAGE

The I<domain specific language> parsed by L<Hash::Weighted::Categorize>
is intentionaly very simple. Simple statements consist of boolean
expressions separated by commas (C<,> meaning I<logical AND>), and
terminated by a colon (C<:>) followed by the result to be returned if
the condition is true.

In the following example:

    %OK > 90%, %CRIT < .1: OK;
    %CRIT > 50%: CRIT;
    %CRIT > 25%: WARN;
    UNKN;

C<OK>, C<WARN>, C<CRIT> and C<UNKN> are I<names>. On the left-hand side of
the C<:>, they are interpreted in relation to the keys of the examined
hash. A I<name> by itself is interpreted as the count/weight of this
element in the hash. When prefixed by a C<%> sign, the ratio of this
category compared to the total is used in the expression.

A literal number followed by a C<%> sign is simply divided by C<100>.

The currently supported mathematical operators are:
C<+>, C<->, C<*> and C</>.

The currently suppored comparison operators are:
C<< < >>, C<< <= >>, C<==>, C<< > >> and C<< >= >>.

=head1 ACKNOWLEDGMENTS

This module was originally developed for Booking.com. With approval from
Booking.com, this module was generalized and put on CPAN, for which the
author would like to express his gratitude.

This module is the result of scratching my colleague Menno Blom's itch
during a company-sponsored hackathon. Thanks to everyone involved.

The name of this module owes a lot to the C<module-authors> mailing-list,
and especially to Aristotle Pagaltzis. Thanks to everyone involved.

=head1 COPYRIGHT

Copyright 2013 Philippe Bruhat (BooK), all rights reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
