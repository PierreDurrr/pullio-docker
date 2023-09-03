FROM ghcr.io/linuxserver/baseimage-alpine:3.16

# Set version label
ARG BUILD_DATE
ARG VERSION
ARG ARR_UPDATE_RELEASE
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="PierreDurrr"

# Install build and runtime dependencies
RUN apk add --no-cache --upgrade --virtual=build-dependencies \
    cargo \
    gcc \
    git \
    jpeg-dev \
    libffi-dev \
    libxslt-dev \
    libxml2-dev \
    musl-dev \
    openssl-dev \
    python3-dev \
    zlib-dev && \
  apk add --no-cache --upgrade \
    tiff \
    py3-setuptools \
    python3 \
    uwsgi \
    uwsgi-python \
    nano \
    curl \
    sshpass

# Define the volume
VOLUME /config 

# Change working directory
WORKDIR /config/scripts/pullio

# Clone ARR-UPDATE repository
RUN curl -fsSL "https://raw.githubusercontent.com/hotio/pullio/master/pullio.sh" -o /config/scripts/pullio

# Set executable permissions for scripts
RUN chmod +x /usr/local/bin/pullio

# Copy crontab file
COPY crontab /etc/crontabs/root

# Start cron daemon
CMD ["crond", "-f", "-l", "2"]
