FILESDIR=$PWD
AR="zig ar"
chroot-git clone https://git.suckless.org/sbase/ &&
cd sbase &&
cp ${FILESDIR}/sbase_mkproto ./scripts/mkproto &&
CC="zig cc" CFLAGS="-static" LD="mold" make -j1 &&
./scripts/mkproto /opt/AltSys/obase/sbase /opt/AltSys/obase/sbase proto &&
cd .. &&
echo "SBASE BUILT CORRECTLY, NOW AT /opt/AltSys/obase/sbase/"
chroot-git clone https://github.com/landley/toybox &&
cd toybox &&
cp -u ${FILESDIR}/toybox_config .config &&
CC="clang" CXX="clang++" CFLAGS="-static -O2 -pipe" PREFIX="/opt/AltSys/toybox/" LD="mold" make -j1 install &&
cd .. &&
echo "TOYBOX BUILT CORRECTLY, NOW AT /opt/AltSys/toybox" &&
chroot-git clone https://git.suckless.org/ubase/ &&
cd ubase &&
cp ${FILESDIR}/ubase_makefile ./Makefile &&
CC="zig cc" CFLAGS="-static" LD="mold" PREFIX="/opt/AltSys/obase/ubase" MANPREFIX="/opt/AltSys/obase/ubase/share/man" make -j1 install &&
cd .. &&
echo "UBASE BUILT CORRECTLY, NOW AT /opt/AltSys/obase/ubase/"
chroot-git clone https://github.com/xplshn/AltSys &&
cd AltSys &&
mkdir -p /opt/AltSys/misc/ &&
cp -ru misc/* /opt/AltSys/misc/ &&
cp -r etc/* /etc/ &&
cp -r bin/* /bin/ &&
cd ..
echo "You are now running an Alt(tered)Sys. Files at /opt/AltSys. Some files at /etc and /bin have been modified."
