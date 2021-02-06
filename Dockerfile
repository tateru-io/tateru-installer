FROM archlinux:base-20201220.0.11678

RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm --needed archiso git base-devel sudo

# Building AUR packages require a builder user
RUN (useradd builder; echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers)
RUN mkdir /customrepo

# Build plymouth
RUN git clone https://aur.archlinux.org/plymouth.git 2>&1 && \
 (cd plymouth; git checkout 30df4f71e565aed366791e74fab225e8320b3946 2>/dev/null && \
  chown builder -R . && \
  sudo -u builder makepkg -s --noconfirm && \
  mv -v *.pkg.tar.* /customrepo/)

# Add all built packages to a custom repo
RUN repo-add /customrepo/customrepo.db.tar.gz /customrepo/*.pkg.tar.*

ADD . /profile

