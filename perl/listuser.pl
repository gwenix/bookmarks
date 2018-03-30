#!/usr/bin/perl
use 5.18.0;
use warnings;

use lib('Bookmarks');
use Bookmarks::Database qw/
  connectDb
  disconnectDb
  runQuery
/;

my $query = qq(
  SELECT (id,username,name) FROM users
);

connectDb;
my $sth = runQuery $query;
disconnectDb;

# users table
#  name | username | id 
# ------+----------+----
print "id\tusername\tname\n";
while (my @row = $sth->fetchrow_array) {
  print "$row[0]";
  my $out = join ("\t", @row);
  print "$out\n";
}
$sth->finish;