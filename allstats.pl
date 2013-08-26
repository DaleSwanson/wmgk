#!/usr/bin/perl
#stats by Dale Swanson July 11 2013
#requires gnuplot


use strict;
use warnings;
use autodie;

#$|++; #autoflush disk buffer


my $station = "WMGK";
my $limit = 15000;
my $inputfile = "allsongs.txt";
my $allbands = "$station.bands.csv";
my $allsongs = "$station.songs.csv";
my $allhours = "$station.hours.csv";
my $playcountsfile = "$station.plays.csv";
my $gnuplotfile = "plot.gp";

my $days = 0;
my $lastday = 0;
my $earliest;
my $latest;
my @filearray; #stores lines of input files
my $fileline; #store individual lines of input file in for loops
my ($year, $mon, $day, $hour, $min);
my $band;
my $song;
my $fullsongname;
my %songs;
my %bands;
my @songplays;
my @hours;

open my $ifile, '<', $inputfile;
@filearray = <$ifile>;
close $ifile;
foreach $fileline (@filearray)
{#go through the songs file, gather data
	#
	if ($fileline =~ m/(\d{4})-(\d{2})-(\d{2});(\d{1,2}):(\d{2});(.+);(.+)/)
	{#1:year 2:month 3:day 4:hour 5:min 6:band 7:song
		$year = $1;
		$mon = $2;
		$day = $3;
		$hour = $4;
		$min = $5;
		$band = $6;
		$song = $7;
		
		if ($day != $lastday) {$days++;}
		$lastday = $day;
		
		$bands{$band}++;
		
		$fullsongname = "$band - $song";
		$songs{$fullsongname}++;
		
		$hours[$hour]++;
		#print "\n$band";
	}
	
}

print "\n$days days\n";
#@songplays = (0) x ($days); 
#my $temp = $bands{Beatles};
##print "\nBeatles - $temp";
#
#$temp = $bands{'Led Zeppelin'};
##print "\nZ - $temp";

open my $ofile, '>', $allbands;
my $i = 0;
foreach $band (sort {$bands{$b} <=> $bands{$a} } keys %bands)
{
	$i++;
	if ($i >= $limit) {last;}
	print "\n$bands{$band} \t$band";
	print $ofile "\n".$bands{$band} / $days * 30 ." \t\"$band\"";
}
close $ofile;

open $ofile, '>', $allsongs;
$i = 0;
foreach $song (sort {$songs{$b} <=> $songs{$a} } keys %songs)
{
	$i++;
	if ($i >= $limit) {last;}
	print "\n$songs{$song} \t$song";
	print $ofile "\n".$songs{$song} / $days * 30 ." \t\"$song\"";
	$songplays[$songs{$song}]++;
	print " - $songplays[$songs{$song}]";
}
close $ofile;

open $ofile, '>', $allhours;
$i = 0;
foreach my $playcount (@hours)
{
	my $nicehour;
	if ($i == 0) {$nicehour = '12 am';}
	elsif ($i <= 12) {$nicehour = "$i am";}
	else {$nicehour = ($i-12).' pm';}
	print "\nHour: $nicehour Plays: $playcount";
	print $ofile "\n$i \t".$playcount / $days;
	$i++;
}
close $ofile;

open $ofile, '>', $playcountsfile;
$i=1;
for ($i=1; $i<$days; $i++)
#until ($songplays[$i] eq '')
{
	#if ($songplays[$i] eq '') {last;}
	$songplays[$i] //= 0;
	print "\n$songplays[$i] $i";
	print $ofile "\n$songplays[$i] $i";
	#$i++;
}
close $ofile;

open my $gfile, '>', $gnuplotfile;
print $gfile <<ENDTEXT;
set terminal png size 1200, 800 enhanced
set font "arial"
set output "$station.topbands.png"
set grid y
set title "$station: Top Bands"
set nokey
set yrange [0:]
set xrange [:50]
set ylabel 'Plays per 30 days'
set xlabel 'Band'
set xtics rotate 
set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.9
plot "$allbands" using 1:xtic(2) ti "Play Count"
ENDTEXT
close $gfile;
system("gnuplot $gnuplotfile");


open $gfile, '>', $gnuplotfile;
print $gfile <<ENDTEXT;
set terminal png size 1200, 800 enhanced
set font "arial"
set output "$station.allbands.png"
set grid y
set title "$station: All Bands"
set nokey
set yrange [0:]
set xrange [:]
set ylabel 'Plays per 30 days'
unset xlabel
unset xtics  
set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.9
plot "$allbands" using 1:xtic(2) ti "Play Count"
ENDTEXT
close $gfile;
system("gnuplot $gnuplotfile");


open  $gfile, '>', $gnuplotfile;
print $gfile <<ENDTEXT;
set terminal png size 1200, 800 enhanced
set font "arial"
set output "$station.topsongs.png"
set grid y
set title "$station: Top Songs"
set nokey
set yrange [0:]
set xrange [:50]
set ylabel 'Plays per 30 days'
set xlabel 'Song'
set xtics rotate 
set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.9
plot "$allsongs" using 1:xtic(2) ti "Play Count"
ENDTEXT
close $gfile;
system("gnuplot $gnuplotfile");

open  $gfile, '>', $gnuplotfile;
print $gfile <<ENDTEXT;
set terminal png size 1200, 800 enhanced
set font "arial"
set output "$station.allsongs.png"
set grid y
set title "$station: All Songs"
set nokey
set yrange [0:]
set xrange [:]
set ylabel 'Plays per 30 days'
unset xlabel
unset xtics
set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.9
plot "$allsongs" using 1:xtic(2) ti "Play Count"
ENDTEXT
close $gfile;
system("gnuplot $gnuplotfile");



open  $gfile, '>', $gnuplotfile;
print $gfile <<ENDTEXT;
set terminal png size 1200, 800 enhanced
set font "arial"
set output "$station.playcounts.png"
set grid y
set title "$station: Songs per Playcount"
set nokey
set yrange [0:]
set xrange [:]
set ylabel 'Number of Songs'
set xlabel 'Play Count'
set xtics rotate 
set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.9
plot "$playcountsfile" using 1:xtic(2) ti "Play Count"
ENDTEXT
close $gfile;
system("gnuplot $gnuplotfile");


open  $gfile, '>', $gnuplotfile;
print $gfile <<ENDTEXT;
set terminal png size 1200, 800 enhanced
set font "arial"
set output "$station.hours.png"
set grid y
set title "$station: Plays per hour of the day"
set nokey
set yrange [0:]
set xrange [:]
set ylabel 'Daily plays in given hour'
set xlabel 'Hour'
set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.9
plot "$allhours" using 2:xtic(1) ti ""
ENDTEXT
close $gfile;
system("gnuplot $gnuplotfile");


print "\nDone\n\n";
