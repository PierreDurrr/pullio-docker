FROM ghcr.io/linuxserver/baseimage-alpine:3.16

# Set version label
ARG BUILD_DATE
ARG VERSION
ARG ARR_UPDATE_RELEASE
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="PierreDurrr"
LABEL org.hotio.pullio.update="true"
LABEL org.hotio.pullio.notify="true"

# Install additional packages
RUN apk add --no-cache --upgrade \
    nano \
    git \
    curl

# Define the volume and create dir
VOLUME /config
RUN cd /config && mkdir scripts && cd scripts

# Change working directory
WORKDIR /config/scripts

# Clone hotio/pullio repository
RUN git clone https://github.com/hotio/pullio.git

# Set executable permissions for scripts
RUN chmod +x /config/scripts/pullio

# Copy crontab file
COPY crontab /etc/crontabs/root

# Start cron daemon
CMD ["crond", "-f", "-l", "2"]
