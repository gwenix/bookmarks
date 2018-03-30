package Bookmarks::Database 0.1;

use 5.18.0;
use warnings;

use base('Exporter');
our @EXPORT_OK = qw/
    connectDb
    disconnectDb
    doQuery
    runQuery
/;

use DBI;
use Constants::DB;

our $dbh;

sub connectDb {
    # Database connection
    $dbh = DBI->connect(
        "dbi:Pg:".
        "dbname=".DB->USER.
        "host=".DB->HOST.
        "port=".DB->PORT,  
        DB->USER, DB->PASS,
        {
            AutoCommit => 0,
            RaiseError => 1
        }
    ) || die $DBI::errstr;
}

sub disconnectDb {
    $dbh->disconnect;
}

sub doQuery {
    my ($class, $sql) = @_;
    $dbh->do($sql)
        || die "DATABASE ERROR: $!";
    return $dbh->commit;
}

sub runQuery {
    my $sql = shift;
    my $sth = $dbh->prepare($sql);
    
    return $sth->execute
        || die "DATABASE ERROR: $!";
}
1;