#!/bin/sh
check_pkg() {
    MISSING_OBLIGATORY=""
    MISSING_OPTIONAL=""
    ALTERNATIVE_OPTIONAL=""

    for pkg in "$@"; do
        if ! command -v "$pkg" >/dev/null 2>&1; then
            case $pkg in
                chroot-git | git )
                    MISSING_OBLIGATORY="$MISSING_OBLIGATORY $pkg"
                    ;;
                source-highlight )
                    MISSING_OPTIONAL="$MISSING_OPTIONAL $pkg"
                    ;;
                curl | sox | mpg123 )
                    if ! command -v curl >/dev/null 2>&1 && ! command -v sox >/dev/null 2>&1 && ! command -v mpg123 >/dev/null 2>&1; then
                        MISSING_OPTIONAL="$MISSING_OPTIONAL $pkg"
                    else
                        ALTERNATIVE_OPTIONAL="$ALTERNATIVE_OPTIONAL $pkg"
                    fi
                    ;;
            esac
        fi
    done

    if [ -n "$MISSING_OBLIGATORY" ]; then
        printf "Missing obligatory dependencies:%s\n" "$MISSING_OBLIGATORY"
    fi

    if [ -n "$MISSING_OPTIONAL" ]; then
        if [ -n "$ALTERNATIVE_OPTIONAL" ]; then
            printf "Missing either %s or %s\n" "$ALTERNATIVE_OPTIONAL"
        else
            printf "Missing optional dependencies:%s\n" "$MISSING_OPTIONAL"
        fi
    fi

    if ! command -v ksh >/dev/null 2>&1; then
        printf "Install a o(KSH) compatible shell. Use OKSH if possible.\n"
    fi
}

# Call the function with both obligatory and optional dependencies
check_pkg chroot-git git source-highlight curl sox mpg123

FILESDIR=$PWD
AR="zig ar"
chroot-git clone https://git.suckless.org/sbase/ &&
cd sbase &&
cp ${FILESDIR}/sbase_mkproto ./scripts/mkproto &&
CC="zig cc" CFLAGS="-static" LD="mold" make -j1 &&
./scripts/mkproto /opt/AltSys/obase/sbase /opt/AltSys/obase/sbase proto &&
cd .. &&
echo "SBASE NOW AVAILABLE AT /opt/AltSys/obase/sbase/"
mkdir -p /opt/AltSys/obase/sbase/share/man/
mv /opt/AltSys/obase/sbase/man /opt/AltSys/obase/sbase/share/man
echo "SBASE's manpages are at /opt/AltSys/obase/sbase/share/man/"
chroot-git clone https://github.com/landley/toybox &&
cd toybox &&
cp -u ${FILESDIR}/toybox_config .config &&
CC="clang" CXX="clang++" CFLAGS="-static -O2 -pipe" PREFIX="/opt/AltSys/toybox/" LD="mold" make -j1 install &&
cd .. &&
echo "TOYBOX NOW AVAILABLE AT /opt/AltSys/toybox" &&
chroot-git clone https://git.suckless.org/ubase/ &&
cd ubase &&
cp ${FILESDIR}/ubase_makefile ./Makefile &&
CC="zig cc" CFLAGS="-static" LD="mold" PREFIX="/opt/AltSys/obase/ubase" MANPREFIX="/opt/AltSys/obase/ubase/share/man" make -j1 install &&
cd .. &&
echo "UBASE NOW AVAILABLE AT /opt/AltSys/obase/ubase/"
echo "UBASE's manpages are at /opt/AltSys/obase/ubase/share/man/"
chroot-git clone https://github.com/xplshn/AltSys &&
cd AltSys &&
mkdir -p /opt/AltSys/misc/ &&
cp -ru misc/* /opt/AltSys/misc/ &&
cp -r etc/* /etc/ &&
cp -r bin/* /bin/ &&
ksh ./SOURCES.sh 2>/dev/null || sh ./SOURCES.sh 2>/dev/null || cat SOURCES &&
cd ..
echo "You are now running an Alt(tered)Sys. Files at /opt/AltSys. Some files at /etc and /bin have been modified."
