#!/bin/bash

APT_PACKAGES="apt-utils ffmpeg libav-tools x264 x265 wget"
apt-install() {
	export DEBIAN_FRONTEND=noninteractive
	apt-get update -q
	apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" $APT_PACKAGES
	return $?
}

#install ffmpeg to container
add-apt-repository -y ppa:jonathonf/ffmpeg-3 2>&1
apt-install || exit 1

#create folders
mkdir data
mkdir data/bin

# get the style file -- in this case, wave.ckpt 
/usr/bin/wget http://kewbeach.ca/fast-style-transfer/wave.ckpt

#run style transfer on video

#run style transfer on video
python transform_video.py --in-path examples/content/fox.mp4 \
  --checkpoint ./wave.ckpt \
  --out-path /artifacts/out.mp4 \
  --device /gpu:0 \
  --batch-size 4 2>&1

#run style transfer on a single image
#python evaluate.py --checkpoint ./scream.ckpt \
#  --in-path examples/WhatsApp\ Image\ 2018-05-10\ at\ 3.34.49\ PM.jpeg \
#  --out-path /artifacts/new.jpg
