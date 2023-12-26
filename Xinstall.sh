#!/bin/sh

# ANSI color codes
GREEN='\033[0;32m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Fixed variables
THREADS="${THREADS:-1}"
FILESDIR="$PWD"
AR="ar"
LD="mold"
LDFLAGS="-static -L/usr/lib/libc.a"

SBASE_CC="clang"
SBASE_CFLAGS="-g -static -O2 -pipe -fPIE"
SBASE_LD="ld"

TOYBOX_CC="clang"
TOYBOX_CXX="clang++"
TOYBOX_CFLAGS="-g -static -O2 -pipe -fPIE"
TOYBOX_LD="$LD"
TOYBOX_PREFIX="/opt/AltSys/toybox/"

BUSYBOX_CC="clang"
BUSYBOX_CXX="clang++"
BUSYBOX_CFLAGS="-g -static -O2 -pipe -fPIE"
BUSYBOX_LD="$LD"
BUSYBOX_PREFIX="/opt/AltSys/busybox"

UBASE_CC="clang"
UBASE_CFLAGS="-g -static -O2 -pipe -fPIE"
UBASE_LD="$LD"
UBASE_PREFIX="/opt/AltSys/obase/ubase"
UBASE_MANPREFIX="/opt/AltSys/obase/ubase/share/man"

# Function to check command existence
check_command() {
    command -v "$1" >/dev/null 2>&1
}

# Function to display missing commands
display_missing_commands() {
    printf "Missing %s. Install it to proceed.\n" "$1"
    exit 1
}

# Decide which GIT to use
if ! command -v chroot-git >/dev/null 2>&1; then
    GIT_CMD="git"
else
    GIT_CMD="chroot-git"
fi

clone_or_update_repo() {
    local repo_name="$1"
    local repo_url="$2"

    if [ -d "$repo_name/.git" ]; then
        # Repository exists, update it
        printf "Updating %s repository...\n" "$repo_name"
        if ! (cd "$repo_name" && "$GIT_CMD" pull); then
            printf "Updating %s repository failed.\n" "$repo_name"
            exit 1
        fi
    else
        # Repository does not exist, clone it
        printf "Cloning %s repository...\n" "$repo_name"
        if ! "$GIT_CMD" clone "$repo_url"; then
            printf "Cloning %s repository failed.\n" "$repo_name"
            exit 1
        fi
    fi
}

if ! check_command "$GIT_CMD"; then
    display_missing_commands "$GIT_CMD"
fi

clone_or_update_repo "sbase" "https://git.suckless.org/sbase/" &&
# Build and install Sbase
cd sbase || exit 1
cp "${FILESDIR}/sbase_mkproto" ./scripts/mkproto
if ! CC="$SBASE_CC" CFLAGS="$SBASE_CFLAGS" LD="$SBASE_LD" make -j"$THREADS" sbase-box > sbase_build.log; then
    printf "Building sbase failed.\n"
    cat sbase_build.log
    exit 1
fi
if ! ./scripts/mkproto /opt/AltSys/obase/sbase /opt/AltSys/obase/sbase proto; then
    printf "Creating sbase directories failed.\n"
    exit 1
fi
cd .. || exit 1
printf "${GREEN}OK:${NC} Installed ${GREEN}sbase${NC} at ${MAGENTA}/opt/AltSys/obase/sbase/${NC}\n"

# Clone Toybox repository
clone_or_update_repo "toybox" "https://github.com/landley/toybox"
# Build and install Toybox
cd toybox || exit 1
cp -u "${FILESDIR}/toybox_config" .config
if ! CC="$TOYBOX_CC" CXX="$TOYBOX_CXX" CFLAGS="$TOYBOX_CFLAGS" PREFIX="$TOYBOX_PREFIX" LD="$TOYBOX_LD" make -j"$THREADS" install > toybox_build.log; then
    printf "Building toybox failed.\n"
    cat toybox_build.log
    exit 1
fi
cd .. || exit 1 &&
printf "${GREEN}OK:${NC} Installed ${GREEN}toybox${NC} at ${MAGENTA}/opt/AltSys/toybox/${NC}\n"

# Clone Busybox repository
clone_or_update_repo "busybox" "https://git.busybox.net/busybox/"
# Build and install Busybox
cd busybox || exit 1
cp -u "${FILESDIR}/busybox_config" .config
if ! CC="$BUSYBOX_CC" CXX="$BUSYBOX_CXX" CFLAGS="$BUSYBOX_CFLAGS" LD="BUSYBOX_LD" make -j"$THREADS" CONFIG_PREFIX="$BUSYBOX_PREFIX" install > busybox_build.log; then
    printf "Building busybox failed.\n"
    cat busybox_build.log
    exit 1
fi
#rm /opt/busybox/linuxrc
cd .. || exit 1 &&
printf "${GREEN}OK:${NC} Installed ${GREEN}busybox${NC} at ${MAGENTA}/opt/AltSys/busybox/${NC}\n"

# Clone Ubase repository
clone_or_update_repo "ubase" "https://git.suckless.org/ubase/"
# Build and install Ubase
cd ubase || exit 1
cp "${FILESDIR}/ubase_makefile" ./Makefile
if ! CC="$UBASE_CC" CFLAGS="$UBASE_CFLAGS" LD="$UBASE_LD" PREFIX="$UBASE_PREFIX" MANPREFIX="$UBASE_MANPREFIX" make -j"$THREADS" install > ubase_build.log; then
    printf "Building ubase failed.\n"
    cat ubase_build.log
    exit 1
fi
cd .. || exit 1 &&
printf "${GREEN}OK:${NC} Installed ${GREEN}ubase${NC} at ${MAGENTA}/opt/AltSys/obase/ubase/${NC}\n"
printf "${GREEN}OK:${NC} ${GREEN}ubase${NC}'s manpages are at ${MAGENTA}/opt/AltSys/obase/ubase/share/man/${NC}\n"

# Copy necessary files to respective directories
mkdir -p /opt/AltSys/misc/
chmod +x misc/bin/*
cp -ru misc/* /opt/AltSys/misc/
cp -r etc/* /etc/
cp -r bin/* /bin/
cp ./SOURCES* /opt/AltSys/

# Execute SOURCES.sh
(ksh ./SOURCES.sh || sh ./SOURCES.sh || cat SOURCES) 2>/dev/null

printf "${GREEN}OK:${NC} You are now running an ${GREEN}Alt(tered)Sys${NC}. Files are at ${MAGENTA}/opt/AltSys/.${NC}\n"

# Execute cowsay message
/opt/AltSys/misc/bin/cowsay -f "$(/opt/AltSys/misc/bin/cowthink -l | grep -vE 'default|small' | shuf -n 1)" "${GREEN}You've done it, Ronny boy! You have liberated yourself from GPL3 (at least on your coreutils)! Now the interesting question is... Now... What do we do with all this space available? I mean, yes, we finally have a UNIX environment (Change the order of PATH, to UBASE>SBASE>TOYBOX for a more UNIXY and 'HARDCORE' experience) in a Linux distro, isn't this 'the dream'?${NC}"
