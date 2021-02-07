#!/bin/sh

if [[ $(tty) =~ /dev/ttyS[0-9] ]]; then
  # Use resize from 'xterm' package to read the terminal size and make curses
  # realize the real size of the terminal instead of the default 80x24.
  resize > /dev/null
fi
