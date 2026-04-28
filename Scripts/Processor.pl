#!/usr/bin/perl

# This Perl script renames sequence headers in a FASTA file. The script takes a FASTA file and adds a prefix followed by an incremental number to each sequence header.
 
$i=1;
$ii = $ARGV[1];
chomp $outtype;
open (sequence,$ARGV[0]) or die "File not found\n";
	while (<sequence>){
	if (/>/){
	print ">$ii.$i\n";
	$i++;}
	else {print $_;}
	}

