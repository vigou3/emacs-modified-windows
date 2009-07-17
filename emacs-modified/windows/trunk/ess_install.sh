#! /bin/sh

. ./Makeconf

EMACS=${PREFIX}/bin/emacs.exe

cd ess-*

## Edit Makeconf file for our purposes
cp -p Makeconf Makeconf.orig
sed \
-e "/^DESTDIR/s#/usr/local#$PREFIX/ess#" \
-e '/^EMACS/s#emacs#'${EMACS}'#' \
-e '/^LISPDIR/s/share\/emacs\/site-lisp/site-lisp\/ess/' \
-e '/^ETCDIR/s/share\/emacs\///' \
-e '/^DOCDIR/s/share\///' Makeconf.orig > Makeconf

## Copy the original Emacs info/dir file to the ess/info directory so
## that ESS can correctly update the file.
#mkdir -p ${PREFIX}/ess/info/
#cp -p ${PREFIX}/emacs-${EMACSVERSION}/info/dir ${PREFIX}/ess/info/

## Build and install
TMPDIR=$TMP make all
make install
