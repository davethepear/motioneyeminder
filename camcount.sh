#! /bin/sh
# Written for my Pi's MotionEye server. Some days it goes crazy with shadows and records thousands of pics

numpix1500 # Normal number of pics per day you want. my pi get sloooow to load over 1500.
maxpix=2500 # Max number... set it however you like, at your own risk!
directory=/var/lib/motion # your picture directory. no closing slash, could cause issues
email=adminguy@localhost.net.com # your email address

#### Nothing else should be messed with unless you know what you're doing! ####
#### I added comments throuout the script on things and what they do ####

# $1 is called from the crontab, typically a number
file=$directory/$1/nomail # First warning, it keeps you from being mailed every ten minutes
file2=$directory/$1/nomail2 # Second warning, if you unpause and keep going...
today=$(date "+%Y-%m-%d")
# if you want it to count the camera's total and not just the day, remove "/$today"
if [ -d "$directory/$1/$today" ]; then
   count=`ls -R $directory/$1/$today | grep -c jpg`
  else
   count=0
fi

if [ -f "$file" ] || [ -f "$file2" ] && [ $count -lt 500 ]; then
    # You can change the message it sends to you. I'm a weird admin, so I send myself weird messages.
    printf "The files may have been cleared, but you're too lazy to erase the nomail... \nI did it for you!" | mail -s "Lazy Admins..." $email
    if [ -f "$file" ]; then  rm $directory/$1/nomail 
    fi
    if [ -f "$file2" ]; then  rm $directory/$1/nomail2
    fi
fi

if [ -f "$file" ] || [ -f "$file2" ]; then
#  a nomail file exists! don't email, just exit.
   exit 1
fi

# Okay, so maybe you were busy and just cleared the pictures... and then ignored it for a week. or unpaused it, because you wanted to keep recording. idk, it happens.
if [ $count -ge 2500 ]; then
   touch $directory/$1/nomail2
   # You can change the message it sends to you. I'm a weird admin, so I send myself weird messages.
   printf "There's $count camera files from Camera $1 and I'm pausing recording on Camera $1. \nClear the files soon and don't forget to unpause the camera!" | mail -s "Camera $1 Files! WTAF?!" $email
   # If you run this from another server, change it to your server.
   wget -O- "http://localhost:7999/$1/detection/pause" >/dev/null
fi

if [ $count -ge 1500 ]; then
   touch $directory/$1/nomail
   # You can change the message it sends to you. I'm a weird admin, so I send myself weird messages.
   printf "There's $count camera files from Camera $1 and I've paused recording on Camera $1. \nYou'll have to clear file $directory/$1/nomail to continue. \nUnpause too!" | mail -s "Camera $1 Files!" $email
   # If you run this from another server, change it to your server.
   wget -O- "http://localhost:7999/$1/detection/pause" >/dev/null
fi
# © Dave the Pear http://www.davethepear.net
