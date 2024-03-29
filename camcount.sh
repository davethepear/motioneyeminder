#!/bin/bash
# Written for my Pi's MotionEye server. Some days it goes crazy with shadows and records thousands of pics
full=80 # Set the percentage of disk use before I nag you about it.
numpix=1500 # Normal number of pics per day you want. my pi get sloooow to load over 1500.
maxpix=2500 # Max number... set it however you like, at your own risk!
omgwtf=5000 # The point when pausing hasn't slowed the flow, it just sends another request to stop
directory=/var/lib/motioneye # your picture directory. no closing slash, could cause issues
email=eat@joes.cafe # your email address

# so camera directories have to start with 0, by default. I don't see a pi running more than 9 cameras.
cameras=$(ls -d $directory/Camera* | grep -c Camera)

# Written for my Pi's MotionEye server. Some days it goes crazy with shadows and records thousands of pics

#### Nothing else should be messed with unless you know what you're doing! ####
#### I added comments throuout the script on things and what they do ####

# This checks the hard drive to make sure you're not filling it completely
fullmail=$directory/fullmailed
df -H $directory | grep -vE '^Filesystem|none|cdrom|boot|tmpfs|loop' | awk '{ print $5 " " $1 }' | while read output;
do
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge $full ] && [ ! -f $fullmail ]; then
    touch $fullmail
    wget -q -O - "http://localhost:7999/0/detection/pause" >/dev/null
    printf "Running out of hard drive space!\nIt's probably pictures!\nPausing ALL camera recordings!" |
    mail -s "Alert from $(hostname): Almost out of disk space $usep%" $email
  fi
# checks to see if things have been cleaned out
  if [ "$usep" -lt "$full" ] && [ -f "$fullmail" ]; then
      rm $fullmail
    wget -q -O - "http://localhost:7999/0/detection/start" >/dev/null
    printf "You found some hard drive space!\nIt was probably pictures...\nResuming camera recordings!" |
    mail -s "Alert from $(hostname): Disk space $usep%" $email
  fi
done

# loop start, wish me luck!
counter=1
while [ $counter -le $cameras ]
  do
file=$directory/Camera$counter/nomail # First warning, it keeps you from being mailed every ten minutes
file2=$directory/Camera$counter/nomail2 # Second warning, if you unpause and keep going...
today=$(date "+%Y-%m-%d")
# if you want it to count the camera's total and not just the day, remove "/$today"
if [ -d "$directory/Camera$counter/$today" ]; then
   count=`ls -R $directory/Camera$counter/$today | grep -c jpg`
   echo "Camera $counter has $count pictures"
   # echo "$HOSTNAME - $counter - $count" > /var/www/html/cam$counter.txt
  else
   count=0
fi

# Something has gone haywire
if [ $count -gt $omgwtf ]; then
   wget -q -O - "http://localhost:7999/$counter/detection/pause" >/dev/null
   exit 1
fi

if [ -f "$file" ] || [ -f "$file2" ] && [ $count -lt 500 ]; then
    # You can change the message it sends to you. I'm a weird admin, so I send myself weird messages.
    printf "The files may have been cleared, unpausing cameras on $(hostname)." | mail -s "Camera recording on $(hostname) resuming..." $email
    wget -q -O - "http://localhost:7999/0/detection/start" >/dev/null
    if [ -f "$file" ]; then  rm $file
    fi
    if [ -f "$file2" ]; then  rm $file2
    fi
fi

# Okay, so maybe you were busy and just cleared the pictures... and then ignored it for a week. or unpaused it, because you wanted to keep recording. idk, it happens.
if [ $count -ge $maxpix ]; then
   if [ ! -f "$file2" ]; then
   # You can change the message it sends to you. I'm a weird admin, so I send myself weird messages.
   printf "There's $count camera files from Camera $counter and I'm pausing recording from Camera $counter on $(hostname). \nClear the files soon and don't forget to unpause the camera!" | mail -s "Camera $counter files on $(hostname)! WTAF?!" $email
   # If you run this from another server, change it to your server.
   wget -q -O - "http://localhost:7999/$counter/detection/pause" >/dev/null
   touch $file2
   fi
fi

if [ $count -ge $numpix ]; then
   if [ ! -f "$file" ]; then
   # You can change the message it sends to you. I'm a weird admin, so I send myself weird messages.
   printf "There's $count camera files from Camera $counter and I've paused recording from Camera $counter on $(hostname). \nYou'll have to clear pictures from $directory/$counter/$today to continue. \nunpause too!" | mail -s "Camera $counter files on $(hostname)!" $email
   # If you run this from another server, change it to your server.
   wget -q -O - "http://localhost:7999/$counter/detection/pause" >/dev/null
   touch $file
   fi
fi
   ((counter++))
  done
exit 0
# © Dave the Pear http://www.davethepear.net
