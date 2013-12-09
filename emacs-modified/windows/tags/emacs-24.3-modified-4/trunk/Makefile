# Makefile for GNU Emacs for Windows Modified

# Copyright (C) 2011 Vincent Goulet

# Author: Vincent Goulet

# This file is part of GNU Emacs for Windows Modified
# http://vgoulet.act.ulaval.ca/emacs

# This Makefile will create a installation wizard to distribute the
# software using Inno Setup.

# Set most variables in Makeconf
include ./Makeconf

TMPDIR=${CURDIR}/tmpdir
ZIPFILE=emacs-${EMACSVERSION}-bin-i386.zip
EMACSDIR=${TMPDIR}/emacs-${EMACSVERSION}

PREFIX=${EMACSDIR}
EMACS=${PREFIX}/bin/emacs.exe
INNOSCRIPT=emacs-modified.iss
INNOSETUP=c:/progra~1/innose~1/iscc.exe
INFOBEFOREFR=InfoBefore-fr.txt
INFOBEFOREEN=InfoBefore-en.txt

# To override ESS variables defined in Makeconf
DESTDIR=${PREFIX}
SITELISP=${DESTDIR}/site-lisp
#LISPDIR=${DESTDIR}/site-lisp
ETCDIR=${DESTDIR}/etc
DOCDIR=${DESTDIR}/doc
INFODIR=${DESTDIR}/info

ESS=ess-${ESSVERSION}
AUCTEX=auctex-${AUCTEXVERSION}
ORG=org-${ORGVERSION}

all : emacs

.PHONY : emacs dir ess auctex exe www clean

emacs : dir ess auctex exe

dir :
	@echo ----- Creating the application in temporary directory...
	if [ -d ${TMPDIR} ]; then rm -rf ${TMPDIR}; fi
	unzip -q ${ZIPFILE} -d ${TMPDIR}
	sed -e '/^AppVerName/s/<VERSION>/${VERSION}/'           \
	    -e '/^AppId/s/<VERSION>/${VERSION}/'  		\
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
	sed -e '/^(defconst/s/<DISTVERSION>/${DISTVERSION}/' \
	    version-modified.el.in > version-modified.el
	cp -p version-modified.el ${SITELISP}/
	cp -dpr lib ${TMPDIR}
	cp -dpr aspell ${TMPDIR}
	cp -a default.el htmlize.el htmlize-view.el InfoAfter*.txt \
	   framepop.el NEWS psvn.el site-start.el version-modified.el \
	   w32-winprint.el \
           ${TMPDIR}

ess :
	@echo ----- Making ESS...
	TMPDIR=${TMP} ${MAKE} EMACS=${EMACS} -C ${ESS} all
	${MAKE} DESTDIR=${DESTDIR} SITELISP=${SITELISP} \
	        ETCDIR=${ETCDIR}/ess DOCDIR=${DOCDIR}/ess \
	        INFODIR=${INFODIR} -C ${ESS} install
	if [ -f ${SITELISP}/ess-site.el ]; then rm ${SITELISP}/ess-site.el; fi
	@echo ----- Done making ESS

org :
	@echo ----- Making org...
	${MAKE} EMACS=${EMACS} -C ${ORG} all
	${MAKE} EMACS=${EMACS} DESTDIR="" lispdir=${LISPDIR}/org \
	        datadir=${ETCDIR}/org infodir=${INFODIR} -C ${ORG} install
	mkdir ${DOCDIR}/org && cp -a ${ORG}/doc/*.pdf ${DOCDIR}/org/
	@echo ----- Done making org

auctex :
	@echo ----- Making AUCTeX...
	cd ${AUCTEX} && ./configure --prefix=${DESTDIR} \
		--datarootdir=${DESTDIR} \
		--without-texmf-dir \
		--with-lispdir=${SITELISP} \
		--with-emacs=${EMACS}
	make -C ${AUCTEX}
	make -C ${AUCTEX} install
	mv ${SITELISP}/auctex/doc/preview.* ${DESTDIR}/doc/auctex
	rmdir ${SITELISP}/auctex/doc
	@echo ----- Done making AUCTeX

exe :
	@echo ----- Building the archive...
	cd ${TMPDIR}/ && cmd /c "${INNOSETUP} ${INNOSCRIPT}"
	rm -rf ${TMPDIR}
	@echo ----- Done building the archive

www :
	@echo ----- Updating web site...
#	cp -p ${DISTNAME}.exe ${WWWLIVE}/htdocs/pub/emacs/
	cp -p NEWS ${WWWLIVE}/htdocs/pub/emacs/NEWS-windows
	cd ${WWWSRC} && svn update
	cd ${WWWSRC}/htdocs/s/emacs/ &&                       \
		sed -e 's/<ESSVERSION>/${ESSVERSION}/g'       \
		    -e 's/<AUCTEXVERSION>/${AUCTEXVERSION}/g' \
		    -e 's/<PSVNVERSION>/${PSVNVERSION}/g'     \
		    -e 's/<VERSION>/${VERSION}/g'             \
		    -e 's/<DISTNAME>/${DISTNAME}/g'           \
		    windows.html.in > windows.html
	cp -p ${WWWSRC}/htdocs/s/emacs/windows.html ${WWWLIVE}/htdocs/s/emacs/
	cd ${WWWSRC}/htdocs/en/s/emacs/ &&                    \
		sed -e 's/<ESSVERSION>/${ESSVERSION}/g'       \
		    -e 's/<AUCTEXVERSION>/${AUCTEXVERSION}/g' \
		    -e 's/<PSVNVERSION>/${PSVNVERSION}/g'     \
		    -e 's/<VERSION>/${VERSION}/g'             \
		    -e 's/<DISTNAME>/${DISTNAME}/g'           \
		    windows.html.in > windows.html
	cp -p ${WWWSRC}/htdocs/en/s/emacs/windows.html ${WWWLIVE}/htdocs/en/s/emacs/
	cd ${WWWLIVE} && ls -lRa > ${WWWSRC}/ls-lRa
	cd ${WWWSRC} && svn ci -m "Update for Emacs Modified for Windows version ${VERSION}"
	svn ci -m "Version ${VERSION}"
	svn cp ${REPOS}/trunk ${REPOS}/tags/${DISTNAME} -m "Tag version ${VERSION}"
	@echo ----- Done updating web site

clean :
	rm -rf ${TMPDIR}
	cd ${ESS} && ${MAKE} clean
	cd ${AUCTEX} && ${MAKE} clean


