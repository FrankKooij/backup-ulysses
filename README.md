# backup-ulysses

Backup your entire Ulysses preferences folder (which includes your sheets, preferences, etc)

Will use [dropbox_uploader.sh](https://github.com/andreafabrizi/Dropbox-Uploader/blob/master/dropbox_uploader.sh) if found, but can easily be used without it (see comments in script).

Upon seeing this script, a Ulysses customer support representative stated to me:

> It sounds like the only thing that can harm your texts now is a zombie apocalypse at the 
> Dropbox headquarters or the heat death of the universe.

(Warning: Usual disclaimers apply, use at your own risk, etc etc.)

## How to use

The easiest way to use this is to set up a [Keyboard Maestro][http://www.keyboardmaestro.com/main/] macro which runs every time [Ulysses](http://www.ulyssesapp.com/) quits, like so:

![](Backup-Ulysses-on-Quit.jpg)

You can download and use [my Keyboard Maestro macro](Backup-Ulysses-on-Quit.kmmacros) if you wish, just 
be sure to change `/usr/local/scripts/backup-ulysses.sh` to the appropriate path on your Mac.


 
