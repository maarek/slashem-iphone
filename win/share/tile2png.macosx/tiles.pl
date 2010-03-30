#!/usr/bin/perl -w
#
# Diffs tilesets between 2 Slash'EM versions.
#
# (c) 2010 Dirk Zimmermann.
#

use Data::Dumper;

# change both base dirs
my $BASE_DIR1 = "/Users/dirk/Documents/xcode/slashem-0.0.7E0";
my $BASE_DIR2 = "/Users/dirk/Documents/xcode/slashem-0.0.7E7F3";

my %TILES1 = (
			  monsters => "$BASE_DIR1/win/share/monsters.txt",
			  objects => "$BASE_DIR1/win/share/objects.txt",
			  other => "$BASE_DIR1/win/share/other.txt"
			 );

my %TILES2 = (
			  monsters => "$BASE_DIR2/win/share/monsters.txt",
			  objects => "$BASE_DIR2/win/share/objects.txt",
			  other => "$BASE_DIR2/win/share/other.txt"
			 );

sub gather_tiles {
  my ($filename) = @_;
  my %tiles;
  my $tiles_ref = \%tiles;
  open TILEFILE, "<$filename" or die "could not read $filename";
  my $index = 0;
  while ($line = <TILEFILE>) {
	my ($num, $name) = ($line =~ /^# tile (\d+) \((.*)\).*/);
	if (defined $num) {
	  push @{$tiles_ref->{tiles}}, $name;
	  $tiles_ref->{names}->{$name} = $index;
	  $index++;
	}
  }
  close TILEFILE;
  return $tiles_ref;
}

sub gather_all_tiles {
  my ($tiles) = @_;
  my %tiles_result;
  foreach $key qw(monsters objects other) {
	my $filename = $tiles->{$key};
	$filename or die "empty filename for $key";
	-e $filename or die "non-existing file for $filename";
	my $tiles_ref = gather_tiles $filename;
	$tiles_result{$key} = $tiles_ref;
  }
  return \%tiles_result;
}

$tile_info1 = gather_all_tiles \%TILES1;
$tile_info2 = gather_all_tiles \%TILES2;

foreach $key qw(monsters objects other) {
  my $index = 0;
  foreach $tile_name1 (@{$tile_info1->{$key}->{tiles}}) {
	my $tile_name2 = $tile_info2->{$key}->{tiles}->[$index];
	if ($tile_name1 ne $tile_name2) {
	  my $index2 = $tile_info1->{$key}->{names}->{$tile_name2};
	  if (!defined $index2) {
		$index2 = "UNDEF";
	  }
	  print "$key $index $tile_name1 -> $tile_name2 ($index2)\n";
	}
	$index++;
  }
}
