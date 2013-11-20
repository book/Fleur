use Test::More;

BEGIN {
 use_ok( 'Fleur::Parser' ) || print "Run, Forrest, Run!\n";
}

my @scores = (
    { result => 'UNKN', data => { OK => 1, CRIT => 1 } },
    { result => 'OK',   data => { OK => 9, CRIT => 1 } },
    { result => 'CRIT', data => { OK => 1, CRIT => 5 } },
    { result => 'CRIT', data => { OK => 2, CRIT => 2, WARN => 3 } },
);

my $fleur;

while( my $input = <DATA> ) {
    $fleur = Fleur::Parser->new;
    $fleur->input( $input );

    my $sub = eval $fleur->Run;
    for my $score ( @scores ) {
        ok( $sub->($score->{data}) eq $score->{result}, "Expect $score->{result}" );
    }
}

done_testing();

__DATA__
%OK>=90%,%CRIT<=10%:OK;%CRIT+%WARN>50%:CRIT;UNKN
%OK>=90%,%CRIT<=.1:OK;%CRIT+%WARN>50%:CRIT;UNKN
OK>=5,%CRIT<=10%:OK;%CRIT+%WARN>50%:CRIT;UNKN
OK >= 5, %CRIT <= 10% : OK; %CRIT + %WARN > 50% : CRIT; UNKN
