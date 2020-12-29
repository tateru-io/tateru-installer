FROM archlinux:base-20201220.0.11678

ADD . /profile

RUN pacman -Sy --noconfirm archiso

