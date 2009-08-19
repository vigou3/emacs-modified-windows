# Makefile for GNU Emacs.app Modified

# Copyright (C) 2009 Vincent Goulet

# Author: Vincent Goulet

# This file is part of GNU Emacs.app Modified
# http://vgoulet.act.ulaval.ca/emacs

# This Makefile will create a disk image to distribute the software.
# The code is based on a Makefile created by Remko Troncon
# (http://el-tramo.be/about).

include ./Makeconf

EMACSDIR=c:/docume~1/vincent/mesdoc~1/emacsm~1/trunk/emacs-${EMACSVERSION}
PREFIX=${EMACSDIR}
EMACS=${PREFIX}/bin/emacs.exe
INNOSCRIPT=emacs-${EMACSVERSION}-modified.iss
INNOSETUP=c:/progra~1/innose~1/iscc.exe

ESS=`ls -d ess-*`
AUCTEX=`ls -d auctex-*`

all : emacs ess auctex dmg

.PHONY : emacs ess auctex exe clean

emacs : auctex ess exe

auctex :
	@echo ----- Making AUCTeX...
	cd ${AUCTEX} && ./configure --prefix=${PREFIX} \
		--datarootdir=${PREFIX} \
		--without-texmf-dir \
		--with-lispdir=${PREFIX}/site-lisp \
		--with-emacs=${EMACS}
	make -C ${AUCTEX}
	make -C ${AUCTEX} install
	mv ${PREFIX}/site-lisp/auctex/doc/preview.* ${PREFIX}/doc/auctex
	rmdir ${PREFIX}/site-lisp/auctex/doc
	@echo ----- Done making AUCTeX

ess : 
	@echo ----- Making ESS...
	cp -p ${ESS}/Makeconf ${ESS}/Makeconf.orig
	sed \
	    -e "/^DESTDIR/s#/usr/local#${PREFIX}#" \
	    -e '/^EMACS/s#emacs#${EMACS}#' \
	    -e '/^LISPDIR/s/share\/emacs\/site-lisp/site-lisp\/ess/' \
	    -e '/^ETCDIR/s/share\/emacs\///' \
	    -e '/^DOCDIR/s/share\///' ${ESS}/Makeconf.orig > ${ESS}/Makeconf
	TMPDIR=${TMP} ${MAKE} -C ${ESS} all 
	${MAKE} -C ${ESS} install
	@echo ----- Done making ESS

exe : 
	@echo ----- Building the archive...
	cp -p ${INNOSCRIPT} ${INNOSCRIPT}.orig
	sed \
	    -e '/^AppVerName/s/modified-.*$$/modified-${VERSION}/' \
	    -e '/^OutputBaseFilename/s/modified-.*$$/modified-${VERSION}/' \
	    ${INNOSCRIPT}.orig > ${INNOSCRIPT}
	rm ${INNOSCRIPT}.orig
	cmd /c "${INNOSETUP} ${INNOSCRIPT}"
	@echo ----- Done building the archive

clean :
	rm -rf ${EMACSDIR}/site-lisp/ess
	rm -rf ${EMACSDIR}/site-lisp/auctex
	rm -rf ${EMACSDIR}/doc
	rm -f ${EMACSDIR}/info/ess.info
	rm -f ${EMACSDIR}/info/auctex.info
	rm -f ${EMACSDIR}/info/preview-latex.info
	sed -e '/^EmacsINFO-DIR-SECTION TeX/,$d' \
	    ${EMACSDIR}/info/dir > ${EMACSDIR}/info/dir.orig
	mv ${EMACSDIR}/info/dir.orig ${EMACSDIR}/info/dir
	cd ${ESS} && ${MAKE} clean
	cd ${AUCTEX} && ${MAKE} clean


