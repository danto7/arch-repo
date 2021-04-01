FROM archlinux/base
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm base-devel && \
    useradd -m builder && \
    echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
WORKDIR /home/builder
USER builder
COPY ./build.sh .
ENTRYPOINT ./build.sh
