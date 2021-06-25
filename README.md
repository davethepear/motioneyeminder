# motioneyeminder
This script written to monitor the number of files my poor Pi4 has in a camera's save directory, pause the camera's recording, and email me that a camera's gone crazy! 
The camcount.sh should be placed in the base directory set in MotionEye.
You will need to add this to your crontab:
> sudo crontab -e
> */10 * * * * /<your base directory set in MotionEye>/camcount.sh 01 # Camera's sub directory

I'm continuing to work on this... I'm kind of new to scripting, in bash.
