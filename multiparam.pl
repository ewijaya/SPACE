#!/usr/bin/perl -w
#===============================================================================
#
#
#===============================================================================
use strict;
use Data::Dumper;
use File::Basename;
use Carp;
use POSIX;


my $input_file = $ARGV[0] || 'test.fasta';
my $species    = $ARGV[1] || 'MM';
my $submot_len = 5;
my $base = basename( $input_file, '.fasta', '.fa', '.txt' );
my @cov_list    = ( 0.5, 0.8 );
my @quorum_list = ( 0.5, 0.9 );
my @wlist       = ( 10,  15 );

my $param_count = 0;


foreach my $w ( @wlist ) {

    foreach my $q ( @quorum_list ) {


        foreach my $cov ( @cov_list ) {

            $param_count++;

            my $ncov = floor( $cov * $w );

            my	$config_file = $base."-".$w."-".$submot_len."-".$ncov."-".$q.'.config';		# output file name
            #print STDERR  "$config_file PARAM $param_count\n";
            print  "$config_file PARAM $param_count\n";

            open ( OUTFILE, '>', $config_file )
                or croak "$0 : failed to open output file $config_file : $!\n";
            
            print OUTFILE "$submot_len\n";
            print OUTFILE "$ncov\n";
            print OUTFILE "$q\n";
            print OUTFILE "$w\n";
            print OUTFILE "FreqFiles/".$species."\.6\.freq\n";
            print OUTFILE "FreqFiles/".$species."\.8\.freq\n";
            print OUTFILE "files/"."$input_file\n";
            print OUTFILE "$base.dat\n";
            
            close ( OUTFILE );			# close output file

            #my	$base_out = $base."-".$w."-".$submot_len."-".$ncov."-".$q.'.out';		# output file name

            my $base_out = $base .".out";
            my $base_dat = $base .".dat";
            my $dir_input_file = "files/".$input_file;

            #print "CAND GENERATION\n";
                system("./generate_v.exe <$dir_input_file>$base_out $config_file");

            #print "FPM\n";
            system("./mining_v.exe<$base_out>$base_dat");
            
            #print "SCORING\n\n";

            print "TAG: ParamGroup".$param_count."\n";
            system("./scoring_v.exe $config_file");

            print "\n\n";
            
            unlink($config_file);
            unlink($base_out);
            unlink($base_dat);

        }               


    }               

    
}               

#1. generate2.exe <d1.fasta>d1.out config
#2. mining2.exe<d1.out>d1.dat
#3.scoring5.exe config







