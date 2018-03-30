#!/usr/bin/perl
use 5.18.0;
use warnings;

use lib('Bookmarks');
use Bookmarks::Database qw/
  connectDb
  disconnectDb
  doQuery
  runQuery
/;

# Getting the user
my $user = shift;
my $name = join ' ';

die "Usage: ./adduser [username] [Real Name]\n"
  unless $name;

$user = lc $user;

# will handle this better later, but atm don't care
# as I'm just trying to set up users for testing
my $pw = 'password';

# users table
#  name | username | id 
# ------+----------+----

# check to make sure they aren't already there.
my $query = qq(
  SELECT name FROM users
  WHERE username = \'$user\';
);

# TEST
# print "$query\n";

connectDb;
my $sth = runQuery($query);

if (my @row = $sth->fetchrow_array) {
  $sth->finish;
  disconnectDb;
  die "User $user already exists.\n";
}
$sth->finish;

$query = qq(
  INSERT INTO users (username, name)
  VALUES (\'$user\', \'$name\');
);

# TEST
# print "Executing $query\n";

doQuery($query);

print "Added $user\n";
disconnectDb;