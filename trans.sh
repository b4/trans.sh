#!/bin/bash

# Initialise global variables
COMMAND=$1
FILENAME=$2
CHANNEL=$3
SUBSTREAM=$4
QUALITY=$5

# Create sme silly little functions
quality() {
 if [ "$QUALITY" = "" ]
  then
   local LQUALITY=22
  else
   local LQUALITY=$QUALITY
 fi
 echo $LQUALITY
}

substream() {
 if [ "$SUBSTREAM" = "" ]
  then
   local LSUBSTREAM=0
  else
   local LSUBSTREAM=$SUBSTREAM
 fi
 echo $LSUBSTREAM
}

if [ "$COMMAND" = "1" ]
then
 ffmpeg -re -i "$FILENAME" -vf "subtitles=$FILENAME:si=`substream`" -threads 2 -crf `quality` -preset ultrafast -c:a aac -strict experimental -ar 44100 -ac 2 -b:a 96k -c:v libx264 -r 25 -b:v 500k -f flv "rtmp://10.12.0.45/live/$CHANNEL"
elif  [ "$COMMAND" = "2" ]
then
 ffmpeg -re -i "$FILENAME" -crf `quality` -threads 2 -preset ultrafast -c:a aac -strict experimental -ar 44100 -ac 2 -b:a 96k -c:v libx264 -r 25 -b:v 500k -f flv "rtmp://10.12.0.45/live/$CHANNEL"
elif  [ "$COMMAND" = "3" ]
then
 ffmpeg -re -i "$FILENAME" -vf "dvd_subtitle=$FILENAME" -threads 2  `quality` $QUALITY -preset ultrafast -c:a aac -strict experimental -ar 44100 -ac 2 -b:a 96k -c:v libx264 -r 25 -b:v 500k -f flv "rtmp://10.12.0.45/live/$CHANNEL"
else
 echo "--Usage:"
 echo "First parameter: subtitle options"
 echo "Second parameter: input file"
 echo "Third parameter: channel to stream to"
 echo "Fourth parameter: Subtitle stream number"
 echo "Fifthh parameter: x264 constant rate factor"
 echo ""
 echo "--Subtitle options:"
 echo "1: ASS-style subtitles in source file"
 echo "2: No subtitles in source file"
 echo "3: DVD subtitles in source file"
 echo ""
 echo "--File options:"
 echo "Filename must be less than 36 characters"
 echo ""
 echo "--Channel name options:"
 echo "US-ASCII channel name on GSORG sync"
 echo ""
 echo "--Subtitle stream options:"
 echo "Specify the subtitle track to use"
 echo ""
 echo "--Constant Rate Factor setting:"
 echo "Default for my streaming is 22, 18-28 supported"
fi
