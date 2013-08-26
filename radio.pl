#!/usr/bin/perl
#Radio Parser by Dale Swanson June 26 2013
#grabs recently played list from WMGK site
#run daily at midnight
#uses lynx


use strict;
use warnings;
use autodie;
use Cwd 'abs_path';
abs_path($0) =~ m/(.*\/)/;
my $dir = $1; #directory path of script

#$|++; #autoflush disk buffer

my ($secnow,$minnow,$hrnow,$daynow,$monnow,$yearnow,$wday,$yday,$isdst)=localtime(time);
my $date = sprintf("%4d-%02d-%02d", $yearnow+1900, $monnow+1, $daynow);
print "\nDate: $date";
my $debug = 0; # set to 1 to avoid downloading, give extra output
my $linxdump = $dir."wmgk.$date.txt";
my $outputfile = $dir."allsongs.txt"; #main file with a record of each play
my $url = "http://www.wmgk.com/broadcasthistory.aspx";

my @filearray; #stores lines of input files
my $fileline; #store individual lines of input file in for loops
my $temp;

my $hour;
my $min;
my $ampm;
my $song;
my $band;
my $tempdate;

#lynx -dump -width=9999 -nolist "http://www.wmgk.com/broadcasthistory.aspx" >dump.txt
$temp = "lynx -dump -width=9999 -nolist \"$url\" > $linxdump";
#print "\n$temp\n";
if (!$debug) {system($temp);} #download page when not debug
if ($debug) {$linxdump = "dump.txt";} #if debug use saved page

open my $ifile, '<', $linxdump;
@filearray = <$ifile>; #put the wmgk page into an array for processing
close $ifile;

open my $ofile, '>>', $outputfile;
foreach $fileline (@filearray)
{#go through the linx dump, gather data
	#   Played on   [7/10/2013]
	if ($fileline =~ m/\s*Played on\s+\[(\d{1,2})\/(\d{1,2})\/(\d{4})\]/)
	{#this line should contain date
		#1: month, 2: day, 3: year
		$tempdate = sprintf("%4d-%02d-%02d", $3, $1, $2);
		
		$date = $tempdate; #always use date from wmgk file, script is ran just after midnight
		#if ($tempdate ne $date)
		#{#wrong day, panic
		#	print "\nWrong Day";
		#	print "\t$date vs $3-$1-$2";
		#	#die("\nWrong Day \t$date vs $3-$1-$2");
		#	$date = $tempdate;
		#}
	} 
	
	#   1:40 PM  "DON'T STOP BELIEVING" - JOURNEY
	#   10:05 AM "LONELY OL' NIGHT" - JOHN MELLENCAMP                         buy on iTunes
	if ($fileline =~ m/\s*(\d{1,2}):(\d{2})\s(AM|PM)\s+\"(.+)\"\s-\s(.+)/)
	{#this line should contain a song
		$hour = $1;
		$min  = $2;
		$ampm = $3;
		$song = $4;
		$band = $5;
		if ($hour == 12) {$hour -= 12;}
		if ($ampm eq "PM") {$hour += 12;}
		$band =~ s/\s+buy on iTunes.*//; #strip ending
		$band =~ s/\s+$//; #strip trailing spaces
		$band =~ s/(['|\w]+)/\u\L$1/g; #Title Case
		$song =~ s/(['|\w]+)/\u\L$1/g; #Title Case
		
		unless ($band =~ m/shoes/i || $band eq '' || $band =~ m/PUBLICAFFAIRS/i|| $band =~ m/wmgk/i)
		{#strip out some non-song entries
			print $ofile "\n$date;$hour:$min;$band;$song";
		}
	}
	
}

close $ofile;

print "\nDone\n\n";
