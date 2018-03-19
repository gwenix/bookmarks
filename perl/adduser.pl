#!/usr/bin/perl

use DBI;


# Getting the user
my $user = shift(@ARGV);
my $name = join(" ",@ARGV);
die "Usage: ./adduser [username] [Real Name]\n" unless $name;
$user = lc($user);
my $pw = 'password'; # will handle this better later, but atm don't care
		     # as I'm just trying to set up users for testing

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

# check to make sure they aren't already there.
my $query = qq(SELECT name FROM users WHERE username = \'$username\';);
my $sth = $dbh->prepare($query);
$sth->execute();
die "User $user already exists\n" if ($sth->fetchrow_array);
$sth->finish();

$query = qq(INSERT INTO users (username, name) VALUES (\'$user\', \'$name\'););
print "Executing $query\n";
my $sth = $dbh->prepare($query);
$sth->execute();
$sth->finish();

print "Added $user\n";
$dbh->disconnect();
