#!/bin/bash

gif_folder=/home/pi/autoplay/jpg
movie_folder=/home/pi/autoplay/mp4

##---------------No edit after this line---------------##

#Exit the script if not running at tty1
if [ "$(tty)" != "/dev/tty1" ]; then
  exit
fi

#ignore case
shopt -s nocaseglob

#Convert Animated GIF to mp4
for f in `ls $gif_folder/*.gif`; do
  /usr/bin/ffmpeg \
    -i $f \
    -movflags +faststart \
    -pix_fmt yuv420p \
    -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" \
    $movie_folder/$(basename $f).mp4
  mv $f $gif_folder/backup/$(basename $jpg_file)
done

#Start the slide show
clear
while true; do
  for f in `ls -v $movie_folder/*.*`; do
    ext="${f##*.}"
    case "$ext" in
      jpg|png)
        /usr/bin/fbi -a -1 -t 10 --noverbose "$f" > /dev/null 2>&1
        ;;
      mp4|avi|mov)
        /usr/bin/vlc --fullscreen --no-osd --play-and-exit "$f" > /dev/null 2>&1
        ;;
    esac
  done
done
