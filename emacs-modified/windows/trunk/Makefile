# Makefile for GNU Emacs.app Modified

# Copyright (C) 2009 Vincent Goulet

# Author: Vincent Goulet

# This file is part of GNU Emacs.app Modified
# http://vgoulet.act.ulaval.ca/emacs

# This Makefile will create a disk image to distribute the software.
# The code is based on a Makefile created by Remko Troncon
# (http://el-tramo.be/about).

include ./Makeconf

TMPDIR=${CURDIR}/tmpdir
EMACSDIR=${TMPDIR}/emacs-${EMACSVERSION}
ZIPFILE=emacs-${EMACSVERSION}-bin-i386.zip

PREFIX=${EMACSDIR}
EMACS=${PREFIX}/bin/emacs.exe
INNOSCRIPT=emacs-modified.iss
INNOSETUP=c:/progra~1/innose~1/iscc.exe
INFOBEFOREFR=InfoBefore-fr.txt
INFOBEFOREEN=InfoBefore-en.txt

# To override ESS variables defined in Makeconf
DESTDIR=${PREFIX}
LISPDIR=${DESTDIR}/site-lisp/ess
ETCDIR=${DESTDIR}/etc/ess
DOCDIR=${DESTDIR}/doc/ess

ESS=ess-${ESSVERSION}
AUCTEX=auctex-${AUCTEXVERSION}

all : emacs

.PHONY : emacs dir auctex ess exe clean

emacs : dir auctex ess exe

dir :
	@echo ----- Creating the application in temporary directory...
	if [ -d ${TMPDIR} ]; then rm -rf ${TMPDIR}; fi
	unzip -q ${ZIPFILE} -d ${TMPDIR}
	sed -e '/^AppVerName/s/<VERSION>/${VERSION}/'           \
	    -e '/^Default/s/<EMACSVERSION>/${EMACSVERSION}/g'   \
	    -e '/^LicenseFile/s/<EMACSVERSION>/${EMACSVERSION}/g'   \
	    -e '/^OutputBaseFilename/s/<DISTNAME>/${DISTNAME}/' \
	    -e '/^Source/s/<EMACSVERSION>/${EMACSVERSION}/' \
	    ${INNOSCRIPT}.in > ${TMPDIR}/${INNOSCRIPT}
	sed -e '/^* ESS/s/<ESSVERSION>/${ESSVERSION}/' \
	    -e '/^* AUCTeX/s/<AUCTEXVERSION>/${AUCTEXVERSION}/' \
	    ${INFOBEFOREFR}.in > ${TMPDIR}/${INFOBEFOREFR}
	sed -e '/^* ESS/s/<ESSVERSION>/${ESSVERSION}/' \
	    -e '/^* AUCTeX/s/<AUCTEXVERSION>/${AUCTEXVERSION}/' \
	    ${INFOBEFOREEN}.in > ${TMPDIR}/${INFOBEFOREEN}
	cp -dpr lib ${TMPDIR}
	cp -dpr aspell ${TMPDIR}
	cp -a htmlize.el htmlize-view.el InfoAfter*.txt framepop.el \
	   NEWS psvn.el site-start.el w32-winprint.el ${TMPDIR}

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
	cd ${TMPDIR}/ && cmd /c "${INNOSETUP} ${INNOSCRIPT}"
	rm -rf ${TMPDIR}
	@echo ----- Done building the archive

clean :
	rm -rf ${TMPDIR}
	cd ${ESS} && ${MAKE} clean
	cd ${AUCTEX} && ${MAKE} clean


