# $1 = image input path
# $2 = audio input path
# $3 = video output path
#
# e.g.
# audio-to-video foo.png foo.wav foo.mkv
#
# https://trac.ffmpeg.org/wiki/Encode/YouTube
# https://superuser.com/questions/547296/resizing-videos-with-ffmpeg-avconv-to-fit-into-static-sized-player/1136305#1136305

set -euxo pipefail

ffmpeg \
  -loop 1 \
  -framerate 2 \
  -i "$1" \
  -i "$2" \
  -s 1080x1080 \
  -c:v libx264 \
  -preset medium \
  -tune stillimage \
  -crf 18 \
  -c:a copy \
  -shortest \
  -fflags +shortest \
  -max_interleave_delta 100M \
  -pix_fmt yuv420p \
  "$3"
