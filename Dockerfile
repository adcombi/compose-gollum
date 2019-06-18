FROM greyltc/archlinux-aur
MAINTAINER khalil gharbaoui <khalil@adcombi.com>

# add rack config file
ADD config.ru /home/docker/config.ru

# install better webserver
RUN yaourt -S --noconfirm --needed ruby-thin

# Install gollum
RUN yaourt -S --noconfirm --needed gollum

# for working in the image
RUN sudo pacman --noconfirm --needed -S vim

# generate self-signed ssl cert
WORKDIR /root

# switch to root
USER 0

# make wiki dir
RUN mkdir /wiki

# set wiki repo directory variable
ENV WIKI_REPO /wiki

# set default login
ENV WIKI_USER gollum
ENV WIKI_PASS gollum

# start gollum
CMD thin start -p 80 -R /home/docker/config.ru
