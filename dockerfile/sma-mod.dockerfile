## Buildstage ##
FROM ghcr.io/linuxserver/baseimage-ubuntu:focal as buildstage
LABEL maintainer="Protektor"

ENV SMA_PATH /usr/local/sma
ENV SMA_FFMPEG_URL https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz

# get python3 and git, and install python libraries
RUN \
  apt-get update && \
  apt-get install -y \
    git && \
# make directory
  mkdir -p /root-layer${SMA_PATH} && \
# download repo
  git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git /root-layer${SMA_PATH}

# update.py sets FFMPEG/FFPROBE paths, updates API key and Sonarr/Radarr settings in autoProcess.ini
COPY extras/ /root-layer${SMA_PATH}/
COPY root/ /root-layer/

FROM scratch

COPY --from=buildstage /root-layer/ /
