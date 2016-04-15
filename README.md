wmgk
====

I suspected that the local classic rock station (102.9 WMGK) played a very limited set of songs over and over again.  I wrote a perl script to scrape their recently played page every night at midnight.  I did that daily for two months, and then wrote some scripts to create graphs of the most played songs, and compare that to the most played songs for the same bands on last.fm.  The long story short is that they do indeed play a very limited set of songs.

Over 60 days WMGK played 14,286 songs, however, there were only 924 unique songs in that list.  What's more the top 10% songs were only 28 unique songs.  The top 50% songs were covered by 172 unique songs.  Consider how few 172 songs is, that is what half of what plays on WMGK comes from.

You can looks at the graphs/ directory to see a ton of graphs.  There is one for each band I could think of to look at, one version is sorted by WMGK plays, and another is sorted by last.fm plays.  There are also overall graphs.  Here are some examples:

![Top Bands](/graphs/WMGK.topbands.png)

![Top Queen Songs](/graphs/WMGK.Queen.topsongs.png)

![Top Who Songs](/graphs/WMGK.Who.topsongs.png)

![Top Led Zeppelin Songs](/graphs/WMGK.Led%20Zeppelin.topsongs2.png)

![WMGK Plays Per Hour](/graphs/WMGK.hours.png)