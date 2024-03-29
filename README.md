# MotionEye Minder
This script written to monitor the number of files my poor Pi4 has in a camera's save directory, pause the camera's recording, and email me that a camera's gone crazy! Pi has issues with speed of loading images over 1500 pics per day. I have written the script further to isolate count by day... if you want it by camera and not the day, remove /$today from count, I'll mark it in the script.

It also keeps track of the drive space to where you save the pictures and will pause the recordings at a set percentage.

The camcount.sh should be placed in the base directory set in MotionEye. I mean, it doesn't necessarily HAVE to be, but it's where I put mine. You can put it where you like, just point the directories elsewhere. Change the variables in camcount.sh to fit your needs:
```
full=80 # Set the percentage of disk use before I nag you about it.
numpix=1500 # Normal number of pics per day you want. my pi get sloooow to load over 1500.
maxpix=2500 # Max number... set it however you like, at your own risk!
omgwtf=5000 # The point when pausing hasn't slowed the flow, it just sends another request to stop
directory=/var/lib/motioneye # your picture directory. no closing slash, could cause issues
email=eat@joes.cafe # your email address
```
that should be all that's needed in this file.

You will need to add some things to your crontab as well.
If you got motioneye working, this should be a breeeeeeze!

Assuming the default directory of /var/lib/motion 
this is set in /etc/motion/motion.conf - mine is different.
in `/var/lib/motion` my cameras were automatically given numbers 01-06, yours may be different.

```
sudo cp camcount.sh /var/lib/motion
chown -R motion /var/lib/motioneye/
```
this is set by editing: `sudo nano /etc/motion/motion.conf` (or your favorite editor)

Make the script executable
```
sudo chmod +x /var/lib/motion/camcount.sh
```
add it to cron, I have used it in root's crontab, trying it now in motion's
```
sudo crontab -e -u motion
```
put something like this in the cron:
```bash
*/10 * * * * /var/lib/motion/camcount.sh # location of camcount.sh
```

I'm continuing to work on this... I'm kind of new to scripting, in bash, but it does work! I'll probably continue to add to this.

## Requirements
- motioneye (duh) https://github.com/ccrisan/motioneye/wiki/%28Install-On-Ubuntu-%2820.04-or-Newer%29
- postfix to send email
