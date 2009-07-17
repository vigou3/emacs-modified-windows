#! /bin/sh

. ./Makeconf

PREFIX=c:/docume~1/vincent/mesdoc~1/emacsm~1/trunk
EMACS=${PREFIX}/emacs-${EMACSVERSION}/bin/emacs.exe
EMACS=${PREFIX}/bin/emacs.exe

cd auctex-*
./configure --prefix=${PREFIX}/auctex \
    --without-texmf-dir \
    --with-lispdir=${PREFIX}/site-lisp \
    --with-emacs=${EMACS}

#make clean
make
make install

# Remove header of the 'dir' info file
#tail -n 4 ${PREFIX}/auctex/info/dir > ${PREFIX}/auctex/info/tmp
#mv ${PREFIX}/auctex/info/tmp ${PREFIX}/auctex/info/dir
