FROM archlinux:latest

ADD . /profile

RUN pacman -Sy --noconfirm archiso

