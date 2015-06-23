#!/usr/bin/perl -w
#===============================================================================
#
#
#===============================================================================
use strict;
use Data::Dumper;
use Carp;
use File::Basename;

my $input_file = $ARGV[0] || 'test.fasta';
my $species    = $ARGV[1] || 'SC';
my $base = basename($input_file,".fasta");
my $scname = $base . "\.sc_out";

system("perl multiparam.pl $input_file $species > $scname");
system("perl advisor.pl $scname");
unlink($scname);
