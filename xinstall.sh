#!/bin/sh
pkg_needed() {
    MISSING=""
    for pkg in "$@"; do
        if ! command -v "$pkg" >/dev/null 2>&1; then
            MISSING="$pkg $MISSING"
        fi
    done

    if [ -n "$MISSING" ]; then
        printf "Please install the following missing packages: %s\n" "$MISSING"
    fi
}

pkg_wanted() {
    AVAILABLE=""
    for pkg in "$@"; do
        if command -v "$pkg" >/dev/null 2>&1; then
            AVAILABLE="$pkg"
            break
        fi
    done

    if [ -n "$AVAILABLE" ]; then
        printf "You can use: %s\n" "$AVAILABLE"
    else
        printf "Optional packages available: %s or %s\n" "$1" "$2"
    fi
}

# Usage of pkg_needed and pkg_wanted functions
pkg_needed chroot-git git
pkg_wanted sox mpg123

if [ -z "$GIT_CMD" ]; then
    echo "Missing either chroot-git or git to clone repositories."
fi

FILESDIR=$PWD
AR="zig ar"
$GIT_CMD clone https://git.suckless.org/sbase/ &&
cd sbase &&
cp ${FILESDIR}/sbase_mkproto ./scripts/mkproto &&
CC="zig cc" CFLAGS="-static" LD="mold" make -j1 &&
./scripts/mkproto /opt/AltSys/obase/sbase /opt/AltSys/obase/sbase proto &&
cd .. &&
echo "SBASE NOW AVAILABLE AT /opt/AltSys/obase/sbase/"
mkdir -p /opt/AltSys/obase/sbase/share/man/
mv /opt/AltSys/obase/sbase/man /opt/AltSys/obase/sbase/share/man
echo "SBASE's manpages are at /opt/AltSys/obase/sbase/share/man/"
$GIT_CMD clone https://github.com/landley/toybox &&
cd toybox &&
cp -u ${FILESDIR}/toybox_config .config &&
CC="clang" CXX="clang++" CFLAGS="-static -O2 -pipe" PREFIX="/opt/AltSys/toybox/" LD="mold" make -j1 install &&
cd .. &&
echo "TOYBOX NOW AVAILABLE AT /opt/AltSys/toybox" &&
$GIT_CMD clone https://git.suckless.org/ubase/ &&
cd ubase &&
cp ${FILESDIR}/ubase_makefile ./Makefile &&
CC="zig cc" CFLAGS="-static" LD="mold" PREFIX="/opt/AltSys/obase/ubase" MANPREFIX="/opt/AltSys/obase/ubase/share/man" make -j1 install &&
cd .. &&
echo "UBASE NOW AVAILABLE AT /opt/AltSys/obase/ubase/"
echo "UBASE's manpages are at /opt/AltSys/obase/ubase/share/man/"
$GIT_CMD clone https://github.com/xplshn/AltSys &&
cd AltSys &&
mkdir -p /opt/AltSys/misc/ &&
cp -ru misc/* /opt/AltSys/misc/ &&
cp -r etc/* /etc/ &&
cp -r bin/* /bin/ &&
ksh ./SOURCES.sh 2>/dev/null || sh ./SOURCES.sh 2>/dev/null || cat SOURCES &&
cd ..
echo "You are now running an Alt(tered)Sys. Files at /opt/AltSys. Some files at /etc and /bin have been modified."
