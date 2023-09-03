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
    postgresql-dev \
    python3-dev \
    zlib-dev && \
  apk add --no-cache --upgrade \
    tiff \
    postgresql-client \
    py3-setuptools \
    python3 \
    uwsgi \
    uwsgi-python \
    nano \
    sshpass

# Clone ARR-UPDATE repository
RUN git clone https://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@github.com/PierreDurrr/arr-update /config

# Install pip packages
RUN python3 -m ensurepip && \
    rm -rf /usr/lib/python*/ensurepip && \
    pip3 install --no-cache-dir -U pip wheel tqdm

# Change working directory
#WORKDIR /config/000-arr-scripts

# Set executable permissions for scripts
#RUN chmod +x *.sh

# Copy crontab file
COPY crontab /etc/crontabs/root

# Start cron daemon
CMD ["crond", "-f", "-l", "2"]

# Define the volume
VOLUME /config
