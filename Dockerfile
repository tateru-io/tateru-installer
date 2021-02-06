FROM archlinux:base-20201220.0.11678

RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm --needed archiso git base-devel sudo

# Building AUR packages require a builder user
RUN (useradd builder; echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers)
RUN mkdir /customrepo

# Add all built packages to a custom repo
# RUN repo-add /customrepo/customrepo.db.tar.gz /customrepo/*.pkg.tar.*

ADD . /profile

