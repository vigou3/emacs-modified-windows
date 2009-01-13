## Edit Makeconf file for our purposes
cp -p Makeconf Makeconf.orig
sed \
-e '/^DESTDIR/s/\/usr\/local/c:\/docume~1\/vincent\/mesdoc~1\/emacsm~1\/trunk\/ess\/site-lisp\/ess/' \
-e '/^EMACS/s/emacs/c:\/docume~1\/vincent\/mesdoc~1\/emacsm~1\/trunk\/emacs-22.3\/bin\/emacs.exe/' \
-e '/^LISPDIR/s/share\/emacs\/site-lisp/lisp/' \
-e '/^INFODIR/d' \
-e '/^ETCDIR/{s/share\/emacs\/etc\/ess/etc/;G;s/$/DOCDIR=\$(PREFIX)\/doc/;G;s/$/INFODIR=\$(DOCDIR)\/info/;}' \
-e '/^DOCDIR/d' Makeconf.orig > Makeconf

## Windows build needs essd-sp6w.el and (not sure) msdos.el
# cp -p lisp/Makefile lisp/Makefile.orig
# sed -e '/^	essa-r.elc/{s/$/ \\/;G;s/$/	essd-sp6w.elc msdos.elc/;}' lisp/Makefile.orig > lisp/Makefile

## Copy more documentation than only the info files
# cp -p doc/Makefile doc/Makefile.orig
# sed -e '/^install/{N;G;s/$/	\$(INSTALL) ess.dvi ess.pdf readme.dvi readme.pdf ..\/README ..\/ANNOUNCE \$(DOCDIR)/;G;s/$/	\$(INSTALL) html\/ess.html html\/readme.html $(DOCDIR)\/html/;G;s/$/	\$(INSTALL) refcard\/refcard.pdf $(DOCDIR)\/refcard/;}' doc/Makefile.orig > doc/Makefile

## Build and install
TMPDIR=$TMP make all
make install
