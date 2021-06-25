# motioneyeminder
This script written to monitor the number of files my poor Pi4 has in a camera's save directory, pause the camera's recording, and email me that a camera's gone crazy! Pi has issues with speed of loading images over 1500 pics per day. I haven't written the script further to isolate count by day...

The camcount.sh should be placed in the base directory set in MotionEye. I mean, it doesn't necessarily HAVE to be, but it's where I put mine. You can put it where you like, just point the directories elsewhere.

You will need to add some things to your crontab as well.
If you got motioneye working, this should be a breeeeeeze!

Assuming the default directory of /var/lib/motion 
this is set in /etc/motion/motion.conf - mine is different.
in /var/lib/motion my cameras were automatically given numbers 01-06, yours may be different.

sudo cp camcount.sh /var/lib/motion # this is set in /etc/motion/motion.conf

sudo chmod +x /var/lib/motion/camcount.sh

sudo crontab -e
  
  */10 * * * * /var/lib/motion/camcount.sh 01 # Camera's sub directory
 
  */10 * * * * /var/lib/motion/camcount.sh 02 # et cetera
  
  */10 * * * * /var/lib/motion/camcount.sh 03 # and so on
  
  */10 * * * * /var/lib/motion/camcount.sh 04 # and so forth, you get the idea

I'm continuing to work on this... I'm kind of new to scripting, in bash, but it does work! I spread it all out because I hated the way this program formatted it into one run-on sentence!
