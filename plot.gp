set terminal png size 1200, 800 enhanced
set font "arial"
set output "WMGK.days.png"
set grid y
set title "WMGK: Plays per day"
set nokey
set yrange [0:]
set xrange [:]
set ylabel 'Daily plays'
set xlabel 'Date'
set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.9
plot "WMGK.days.csv" using 2:xtic(1) ti ""
