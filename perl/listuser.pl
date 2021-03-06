#!/usr/bin/perl

use DBI;


# Database connection
my $dbname = 'linkdb';  
my $host = 'localhost';  
my $port = 5432;  
my $dbuser = 'gwen';  
my $dbpw = 'password123';  # yah, will do better passwording later

my $dbh = DBI -> connect("dbi:Pg:dbname=$dbname;host=$host;port=$port",  
                            $dbuser,
                            $dbpw,
                            {AutoCommit => 0, RaiseError => 1}
                         ) or die $DBI::errstr;

# users table
#  name | username | id 
# ------+----------+----

my $query = qq(SELECT (id,username,name) FROM users);
my $sth = $dbh->prepare($query);
$sth->execute();
print "id\tusername\tname\n";
while (my @row = $sth->fetchrow_array) {
  print "$row[0]";
  my $out = join ("\t", @row);
  print "$out\n";
}
$sth->finish();

$dbh->disconnect();
