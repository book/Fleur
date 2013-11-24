use strict;
use warnings;
use Test::More;
use Fleur;

my @scores = (
    { result => 'UNKN', data => { OK => 1, CRIT => 1 } },
    { result => 'OK',   data => { OK => 9, CRIT => 1 } },
    { result => 'CRIT', data => { OK => 1, CRIT => 5 } },
    { result => 'CRIT', data => { OK => 2, CRIT => 2, WARN => 3 } },
);

my $fleur = Fleur->new;

while( my $input = <DATA> ) {
    my $sub = $fleur->parse($input);
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
