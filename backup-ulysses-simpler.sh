#!/bin/zsh -f
# Purpose: Make extra Ulysses backups because you're paranoid. No I'm not. Yes you are. Ok, yeah, that's fair.
#
#
# I sent an earlier version of this to the Ulysses developers, and was told:
# 	"It sounds like the only thing that can harm your texts now is a zombie apocalypse at
#	 the Dropbox headquarters or the heat death of the universe."
#
#
#
# From:	Timothy J. Luoma
# Mail:	luomat at gmail dot com
# Date:	2016-03-09


	# This is where the archives will be saved when finishes
	# it will be created if it does not exist
ARCHIVE_DIR="$HOME/Dropbox/Backups/Ulysses/"


####|####|####|####|####|####|####|####|####|####|####|####|####|####|####
#
#		You should not need to change anything below this line,
#		although you are welcome to if you know what you are doing.
#
####|####|####|####|####|####|####|####|####|####|####|####|####|####|####


# short name of this file without path or extension
NAME="backup-ulysses"

if [ -e "$HOME/.path" ]
then
	source "$HOME/.path"
else
	PATH='/usr/local/scripts:/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin'
fi

zmodload zsh/datetime

TIME=`strftime "%Y-%m-%d--%H.%M.%S" "$EPOCHSECONDS"`

function timestamp { strftime "%Y-%m-%d--%H.%M.%S" "$EPOCHSECONDS" }

LOG="$HOME/Library/Logs/$NAME.log"

function msg {

	echo "$NAME: $@" | tee -a "$LOG"

		# If growlnotify is installed in $PATH
		# use it to report messages
	if (( $+commands[growlnotify] ))
	then

		growlnotify  \
			--appIcon "Ulysses" \
			--identifier "$NAME" \
			--message "$@" \
			--title "$NAME"
	fi

}


####|####|####|####|####|####|####|####|####|####|####|####|####|####|####
#
# make sure the folder that we want to backup actually exists
#

cd "$HOME/Library/Containers"

if [ ! -d "com.soulmen.ulysses3" ]
then
		msg "No com.soulmen.ulysses3 found in $PWD"
		exit 0
fi



####|####|####|####|####|####|####|####|####|####|####|####|####|####|####
#
# This is where we actually create the backup of the folder
#
# The filename will be something like this:
#
# 	com.soulmen.ulysses3.2016-03-09--16.52.51.tar.xz
#
# for March 9th at 4:52pm

if (( $+commands[xz] ))
then

	ARCHIVE="com.soulmen.ulysses3.`timestamp`.tar.xz"

	tar \
		--options='xz:compression-level=9' \
		--xz \
		--verbose \
		-c \
		-f "$ARCHIVE" \
		"com.soulmen.ulysses3"

else

	ARCHIVE="com.soulmen.ulysses3.`timestamp`.tar.bz2"

	tar \
		--verbose \
		-y \
		-c \
		-f "$ARCHIVE" \
		"com.soulmen.ulysses3"

fi


EXIT="$?"

if [ "$EXIT" != "0" ]
then
	msg "tar failed (\$EXIT = $EXIT)"

	exit 0
fi


####|####|####|####|####|####|####|####|####|####|####|####|####|####|####
##
##	Move the .tar.xz pr .tar.bz2 file to the 'ARCHIVE_DIR'
##	which is defined above
##


[[ ! -d "$ARCHIVE_DIR" ]] && mkdir -p "$ARCHIVE_DIR"

mv "$ARCHIVE" "$ARCHIVE_DIR" 2>&1 | tee -a "$LOG"

EXIT="$?"

if [ "$EXIT" = "0" ]
then
	msg "Saved $ARCHIVE to $ARCHIVE_DIR"
else
	msg "Created $ARCHIVE but failed to move it to $ARCHIVE_DIR"
fi



exit 0
#EOF
