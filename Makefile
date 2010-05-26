# Makefile for GNU Emacs.app Modified

# Copyright (C) 2009 Vincent Goulet

# Author: Vincent Goulet

# This file is part of GNU Emacs.app Modified
# http://vgoulet.act.ulaval.ca/emacs

# This Makefile will create a disk image to distribute the software.
# The code is based on a Makefile created by Remko Troncon
# (http://el-tramo.be/about).

include ./Makeconf

EMACSDIR=c:/emacs-modified/trunk/emacs-${EMACSVERSION}
PREFIX=${EMACSDIR}
EMACS=${PREFIX}/bin/emacs.exe
INNOSCRIPT=emacs-modified.iss
INNOSETUP=c:/progra~1/innose~1/iscc.exe
INFOBEFOREFR=InfoBefore-fr.txt
INFOBEFOREEN=InfoBefore-en.txt

# To override ESS variables defined in Makeconf
DESTDIR=${PREFIX}
LISPDIR=${PREFIX}/site-lisp/ess
ETCDIR=${PREFIX}/etc/ess
DOCDIR=${PREFIX}/doc/ess

ESS=ess-${ESSVERSION}
AUCTEX=auctex-${AUCTEXVERSION}

all : emacs

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
	TMPDIR=${TMP} ${MAKE} EMACS=${EMACS} -C ${ESS} all 
	${MAKE} DESTDIR=${DESTDIR} LISPDIR=${LISPDIR} \
	        ETCDIR=${ETCDIR} DOCDIR=${DOCDIR} -C ${ESS} install
	@echo ----- Done making ESS

exe : 
	@echo ----- Building the archive...
	sed -e '/^AppVerName/s/<VERSION>/${VERSION}/'           \
	    -e '/^Default/s/<EMACSVERSION>/${EMACSVERSION}/g'   \
	    -e '/^LicenseFile/s/<EMACSVERSION>/${EMACSVERSION}/g'   \
	    -e '/^OutputBaseFilename/s/<DISTNAME>/${DISTNAME}/' \
	    ${INNOSCRIPT}.in > ${INNOSCRIPT}
	sed -e '/^* ESS/s/<ESSVERSION>/${ESSVERSION}/' \
	    -e '/^* AUCTeX/s/<AUCTEXVERSION>/${AUCTEXVERSION}/' \
	    ${INFOBEFOREFR}.in > ${INFOBEFOREFR}
	sed -e '/^* ESS/s/<ESSVERSION>/${ESSVERSION}/' \
	    -e '/^* AUCTeX/s/<AUCTEXVERSION>/${AUCTEXVERSION}/' \
	    ${INFOBEFOREEN}.in > ${INFOBEFOREEN}
	cmd /c "${INNOSETUP} ${INNOSCRIPT}"
	@echo ----- Done building the archive

clean :
	rm -rf ${EMACSDIR}/site-lisp/ess
	rm -rf ${EMACSDIR}/site-lisp/auctex
	rm -rf ${EMACSDIR}/doc
	rm -f ${EMACSDIR}/info/ess.info
	rm -f ${EMACSDIR}/info/auctex.info
	rm -f ${EMACSDIR}/info/preview-latex.info
	sed -e '/^TeX/,$$d' \
	    ${EMACSDIR}/info/dir > ${EMACSDIR}/info/dir.orig
	mv ${EMACSDIR}/info/dir.orig ${EMACSDIR}/info/dir
	cd ${ESS} && ${MAKE} clean
	cd ${AUCTEX} && ${MAKE} clean


