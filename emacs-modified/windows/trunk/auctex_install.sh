#! /bin/sh

. ./Makeconf

PREFIX=c:/docume~1/vincent/mesdoc~1/emacsm~1/trunk
EMACS=${PREFIX}/emacs-${EMACSVERSION}/bin/emacs.exe

cd auctex-*
./configure --prefix=${PREFIX}/auctex \
    --datarootdir=${PREFIX}/auctex --without-texmf-dir \
    --with-lispdir=${PREFIX}/auctex/site-lisp \
    --with-emacs=${EMACS}

#./configure --prefix="c:/documents and settings/vincent/mes documents/emacs modified/trunk/auctex/" --docdir="c:/docume~1/vincent/mesdoc~1/emacsm~1/trunk/auctex/site-lisp/auctex/doc" --infodir="c:/documents and settings/vincent/mes documents/emacs modified/trunk/auctex/site-lisp/auctex/doc/info/" --without-texmf-dir --with-lispdir="c:/documents and settings/vincent/mes documents/emacs modified/trunk/auctex/site-lisp" --with-emacs=${EMACS}
make clean
make
make install
