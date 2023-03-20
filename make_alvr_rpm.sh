#!/usr/bin/env bash

# 1. Copy this to the ALVR root dir.
# 2. Change the version to match the checked out ALVR version.
# 3. 

ALVR_VERSION="19.1.0"


CUR_DIR=$(pwd)
echo ${CUR_DIR}

if ! command -v fpm &> /dev/null
then
    echo "fpm could not be found"
    gem install fpm
    sudo dnf install -y pipewire-jack-audio-connection-kit-devel cairo-gobject-devel \
                     cargo clang-devel rust rust-atk-sys-devel rust-cairo-sys-rs-devel \
                     rust-gdk-sys-devel rust-glib-sys-devel rust-pango-sys-devel \
                     selinux-policy-devel
    exit
fi

fpm \
  --verbose \
  -s dir -t rpm \
  --name ALVR \
  --version "${ALVR_VERSION}" \
  --license MIT \
  --depends ffmpeg \
  --depends vulkan-headers \
  --depends steam \
  --depends vulkan-validation-layers \
  --description "Stream VR games from your PC to your headset via Wi-Fi" \
  --url "https://github.com/alvr-org/ALVR" \
  --maintainer "hendy643 <hendy643@hotmail.com>" \
  --rpm-compression gzip \
  --rpm-tag 'Requires(post): policycoreutils' \
  --rpm-tag 'Requires(postun): policycoreutils' \
  --rpm-os linux \
  --rpm-auto-add-directories \
  ${CUR_DIR}/build/alvr_server_linux/bin/alvr_launcher=/usr/local/bin/alvr_launcher \
  ${CUR_DIR}/build/alvr_server_linux/lib64/alvr/=/usr/local/lib64/alvr \
  ${CUR_DIR}/build/alvr_server_linux/share/alvr/=/usr/local/share/alvr
