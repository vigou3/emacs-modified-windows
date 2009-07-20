#! /bin/sh

. ./Makeconf

EMACS=${PREFIX}/bin/emacs.exe

cd auctex-*
./configure --prefix=${PREFIX} \
    --datarootdir=${PREFIX} --without-texmf-dir \
    --with-lispdir=${PREFIX}/site-lisp \
    --with-emacs=${EMACS}

#make clean
make
make install

# I can't seem to get preview documentation to install into
# ${PREFIX}/doc/auctex. Move the file there by hand.
mv ${PREFIX}/site-lisp/auctex/doc/preview.* ${PREFIX}/doc/auctex
rmdir ${PREFIX}/site-lisp/auctex/doc

# Remove header of the 'dir' info file
#tail -n 4 ${PREFIX}/auctex/info/dir > ${PREFIX}/auctex/info/tmp
#mv ${PREFIX}/auctex/info/tmp ${PREFIX}/auctex/info/dir
