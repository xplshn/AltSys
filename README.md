# This is an experimental project.
### AltSys configures toybox+ubase+sbase (in that order) as your default coreutils, but without actually uninstalling them. This script was made for Void, but it might work on other systems.
##### I DO NOT TAKE ANY RESPONSABILITY FOR BREAKAGES, LOST OF FILES, ETC.
###### Do not mind the janky scripts I made to get sbase to work. (make install on sbase is done by a stupid, undocumented little piece of (POSIX)s**ll script)

```install guide
$ sudo -i || su
# xbps-install -yu make zig libutf8proc-devel binutils clang zlib-devel libtls-devel mold libutf8proc-devel coreutils sed tree
# git clone https://github.com/xplshn/AltSys/ || chroot-git clone https://github.com/xplshn/AltSys/
# cd AltSys && sh ./xinstall.sh && xbps-remove -ORo make zig sed libutf8proc-devel binutils clang zlib-devel libtls-devel mold binutils libutf8proc-devel coreutils
# tree /opt/AltSys
# exit
```
[![asciicast](https://asciinema.org/a/627368.svg)](https://asciinema.org/a/627368)

I initially also wanted to provide OpenPAM and slicer69's Doas port for Linux, but I figured that is out of the scope for this script(In the future, a package).

### Please check every script at /etc/runit/ if you actually want to replace your coreutils. Runit relies on lots of scripts, which contain bashisms, GNUisms, and aren't really as POSIX as they might seem at first, a good way to test if a script is realiable is to use mKSH or oKSH(Isn't as POSIX as it should be, but is easier to use than mKSH for newbies and to port scripts from sh and bash).

###### V0.0.1-2023-12-17_07:50AM GTM-03
