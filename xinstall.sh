#!/bin/sh
if command -v chroot-git >/dev/null 2>&1; then
    GIT_CMD="chroot-git"
elif command -v git >/dev/null 2>&1; then
    GIT_CMD="git"
else
    echo "Neither chroot-git nor git is installed."
fi
if [ -z "$GIT_CMD" ]; then
    echo "Missing either chroot-git or git to clone repositories."
fi

if ! command -v play >/dev/null 2>&1 && ! command -v mpg123 >/dev/null 2>&1; then
    echo "Neither play (from sox) nor mpg123 are installed. Install one of them if you want to be able to use TTTS(TTS engine that uses a public API)"
fi
if ! command -v curl >/dev/null 2>&1; then
    echo "Install Curl if you want to be able to use TTTS(TTS engine that uses a public API)"
fi

if [ -z "${THREADS}" ]; then
    THREADS=1
fi

FILESDIR=$PWD
AR="zig ar"
$GIT_CMD clone https://git.suckless.org/sbase/ &&
cd sbase &&
cp ${FILESDIR}/sbase_mkproto ./scripts/mkproto &&
CC="zig cc" CFLAGS="-static" LD="mold" make -j${THREADS} sbase-box &&
./scripts/mkproto /opt/AltSys/obase/sbase /opt/AltSys/obase/sbase proto &&
cd .. &&
echo "SBASE NOW AVAILABLE AT /opt/AltSys/obase/sbase/" &&
mkdir -p /opt/AltSys/obase/sbase/share/man/ &&
mv /opt/AltSys/obase/sbase/man /opt/AltSys/obase/sbase/share/man &&
echo "SBASE's manpages are at /opt/AltSys/obase/sbase/share/man/" &&
rm -rf ./sbase/ &&
$GIT_CMD clone https://github.com/landley/toybox &&
cd toybox &&
cp -u ${FILESDIR}/toybox_config .config &&
CC="clang" CXX="clang++" CFLAGS="-static -O2 -pipe" PREFIX="/opt/AltSys/toybox/" LD="mold" make -j${THREADS} install &&
cd .. &&
echo "TOYBOX NOW AVAILABLE AT /opt/AltSys/toybox" &&
$GIT_CMD clone https://git.suckless.org/ubase/ &&
cd ubase &&
cp ${FILESDIR}/ubase_makefile ./Makefile &&
CC="zig cc" CFLAGS="-static" LD="mold" PREFIX="/opt/AltSys/obase/ubase" MANPREFIX="/opt/AltSys/obase/ubase/share/man" make -j${THREADS} install &&
cd .. &&
echo "UBASE NOW AVAILABLE AT /opt/AltSys/obase/ubase/" &&
echo "UBASE's manpages are at /opt/AltSys/obase/ubase/share/man/" &&
#cargo install --root /opt/AltSys/core/gutils coreutils --features unix &&
#$GIT_CMD clone https://github.com/xplshn/AltSys &&
#cd AltSys &&
mkdir -p /opt/AltSys/misc/ &&
chmod +x misc/bin/* &&
cp -ru misc/* /opt/AltSys/misc/ &&
cp -r etc/* /etc/ &&
cp -r bin/* /bin/ &&
cp ./SOURCES* /opt/AltSys/ &&
sh ./SOURCES.sh 2>/dev/null #|| cat SOURCES &&
#cd .. &&
echo "You are now running an Alt(tered)Sys. Files are at /opt/AltSys. Some files at /etc and /bin have been modified in order to get Runit to behave kindly with POSIX."
/opt/AltSys/misc/bin/cowsay "You've done it, Ronny boy! You have liberated yourself from GPL3 (at least on your coreutils)! Now the interesting question is... Now... What do we do with all this space available? I mean, yes, we finally have a UNIX environment(Change the order of PATH, to UBASE>SBASE>TOYBOX for a more UNIXY and 'HARDCORE' experience) in a Linux distro, isn't this 'the dream'?"
