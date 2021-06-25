#! /bin/sh
# Written for my Pi's MotionEye server. Some days it goes crazy with shadows and records thousands of pics

directory=/media/motioneye # your picture directory. no closing slash, could cause issues
email=adminguy@localhost.net.com # your email address

#### Nothing else should be messed with unless you know what you're doing! ####

file=$directory/$1/nomail # First warning, it keeps you from being mailed every ten minutes
file2=$directory/$1/nomail2 # Second warning, if you unpause and keep going...
count=`ls -R $directory/$1 | grep -c jpg` # counts the files in the directory

if [ -f "$file" ] || [ -f "$file2" ] && [ $count -lt 500 ]; then
    printf "The files may have been cleared, but you're too lazy to erase the nomail... \nI did it for you!" | mail -s "Lazy Admins..." $email
    if [ -f "$file" ]; then  rm $directory/$1/nomail 
    fi
    if [ -f "$file2" ]; then  rm $directory/$1/nomail2
    fi
fi

if [ -f "$file" ] || [ -f "$file2" ]; then
#   echo "a nomail file exists! sudo rm $directory/$1/nomail"
   exit 1
fi

# Okay, so maybe you were busy and just cleared the pictures... and then ignored it for a week. or unpaused it, because you wanted to keep recording. idk, it happens.
if [ $count -ge 2500 ]; then
   touch $directory/$1/nomail2
   printf "There's $count camera files from Camera $1 and I'm pausing recording on Camera $1. \nClear the files soon and don't forget to unpause the camera!" | mail -s "Camera $1 Files! HO-LEE-SHIT!" $email
   wget -O- "http://localhost:7999/$1/detection/pause" >/dev/null
fi

# Pi has issues with speed of loading images over 1500 pics per day. I haven't written the script further to isolate count by day...
if [ $count -ge 1500 ]; then
   touch $directory/$1/nomail
   printf "There's $count camera files from Camera $1 and I've paused recording on Camera $1. \nYou'll have to clear file $directory/$1/nomail to continue. \nUnpause too!" | mail -s "Camera $1 Files!" $email
   wget -O- "http://localhost:7999/$1/detection/pause" >/dev/null
fi
# © Dave the Pear http://www.davethepear.net
