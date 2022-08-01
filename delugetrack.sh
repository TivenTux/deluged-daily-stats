#!/bin/bash
###daily deluged bandwidth stats
##works as is for root cron job, to use with normal user give appropriate rights

#remove old stats
rm /srv/delugestats/deluge55.txt
#rename previous stats
mv /srv/delugestats/deluge5.txt /srv/delugestats/deluge55.txt
#read last lines that contain the data needed from deluge database and save on new stats file
tail -n 5 /var/lib/deluge/.config/deluge/stats.totals > /srv/delugestats/deluge5.txt
#keep only numbers from the strings 
sed -i 's/[^0-9]//g' /srv/delugestats/deluge5.txt
#load current stats
line1=$(sed '1q;d' /srv/delugestats/deluge5.txt)
line2=$(sed '2q;d' /srv/delugestats/deluge5.txt)
line3=$(sed '3q;d' /srv/delugestats/deluge5.txt)
line4=$(sed '4q;d' /srv/delugestats/deluge5.txt)
#load previous stats
line11=$(sed '1q;d' /srv/delugestats/deluge55.txt)
line22=$(sed '2q;d' /srv/delugestats/deluge55.txt)
line33=$(sed '3q;d' /srv/delugestats/deluge55.txt)
line44=$(sed '4q;d' /srv/delugestats/deluge55.txt)
#compare
num1="$((((line1-line11))/1000000))"
num2="$((((line2-line22))/1000000))"
num3="$((((line3-line33))/1000000))"
num4="$((((line4-line44))/1000000))"
#log stats, use for logwatch or anywhere else 
echo "$(date) --- daily bandwidth used in MB ----" >> /srv/delugestats/delugestats.log
echo "total download: $((num1))" >> /srv/delugestats/delugestats.log
echo "total upload: $((num4))" >> /srv/delugestats/delugestats.log
echo "payload download: $((num2))" >> /srv/delugestats/delugestats.log
echo "payload upload: $((num3))" >> /srv/delugestats/delugestats.log

