package Fleur;

# code eval'ed by Fleur
# will have none of the extras lexically provided by Moo
sub __eval { eval shift }

use Moo;

use Fleur::Parser;

has _parser => (
    is      => 'lazy',
);

sub _build__parser {
    my ($self) = @_;
    return Fleur::Parser->new();
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
