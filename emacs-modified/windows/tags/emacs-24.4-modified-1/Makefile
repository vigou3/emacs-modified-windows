# Makefile for GNU Emacs for Windows Modified

# Copyright (C) 2014 Vincent Goulet

# Author: Vincent Goulet

# This file is part of GNU Emacs for Windows Modified
# http://vgoulet.act.ulaval.ca/emacs

# This Makefile will create a installation wizard to distribute the
# software using Inno Setup.

# Set most variables in Makeconf
include ./Makeconf

TMPDIR=${CURDIR}/tmpdir
ZIPFILE=emacs-${EMACSVERSION}-bin-${ARCH}.zip
EMACSDIR=${TMPDIR}

PREFIX=${EMACSDIR}
EMACS=${PREFIX}/bin/emacs.exe
EMACSBATCH = $(EMACS) -batch -no-site-file -no-init-file
INNOSCRIPT=emacs-modified.iss
INNOSETUP=c:/progra~1/innose~1/iscc.exe
INFOBEFOREFR=InfoBefore-fr.txt
INFOBEFOREEN=InfoBefore-en.txt

DESTDIR=${PREFIX}/share/
SITELISP=${DESTDIR}/emacs/site-lisp
ETCDIR=${DESTDIR}/emacs/etc
DOCDIR=${DESTDIR}/doc
INFODIR=${DESTDIR}/info

ESS=ess-${ESSVERSION}
AUCTEX=auctex-${AUCTEXVERSION}
ORG=org-${ORGVERSION}

all : emacs

.PHONY : emacs dir ess auctex org polymode exe www clean

emacs : dir ess auctex org polymode exe

dir :
	@echo ----- Creating the application in temporary directory...
	if [ -d ${TMPDIR} ]; then rm -rf ${TMPDIR}; fi
	unzip -q ${ZIPFILE} -d ${TMPDIR}
	cp -p lib/* ${PREFIX}/bin
	cp -dpr aspell ${PREFIX}
	cp -p site-start.el ${SITELISP}/
	sed -e '/^(defconst/s/<DISTVERSION>/${DISTVERSION}/' \
	    version-modified.el.in > version-modified.el
	cp -p version-modified.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/version-modified.el
	cp -p framepop.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/framepop.el
	cp -p psvn.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/psvn.el
	cp -p w32-winprint.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/w32-winprint.el
	cp -p htmlize.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/htmlize.el
	cp -p htmlize-view.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/htmlize-view.el
	sed -e '/^AppVerName/s/<VERSION>/${VERSION}/'           \
	    -e '/^AppId/s/<VERSION>/${VERSION}/'  		\
	    -e '/^Default/s/<EMACSVERSION>/${EMACSVERSION}/g'   \
	    -e '/^LicenseFile/s/<EMACSVERSION>/${EMACSVERSION}/g'   \
	    -e '/^OutputBaseFilename/s/<DISTNAME>/${DISTNAME}/' \
	    -e '/^Filename/s/<EMACSVERSION>/${EMACSVERSION}/' \
	    -e '/^Source/s/<EMACSVERSION>/${EMACSVERSION}/g' \
	    ${INNOSCRIPT}.in > ${INNOSCRIPT}
	sed -e '/^* ESS/s/<ESSVERSION>/${ESSVERSION}/' \
	    -e '/^* AUCTeX/s/<AUCTEXVERSION>/${AUCTEXVERSION}/' \
	    -e '/^* org/s/<ORGVERSION>/${ORGVERSION}/' \
	    -e '/^* polymode/s/<POLYMODEVERSION>/${POLYMODEVERSION}/' \
	    -e '/^* polymode/s/<MARKDOWNMODEVERSION>/${MARKDOWNMODEVERSION}/' \
	    -e '/^* psvn/s/<PSVNVERSION>/${PSVNVERSION}/' \
		    README-Modified.txt.in > README-Modified.txt
	cp -p default.el README-Modified.txt NEWS ${INNOSCRIPT} ${TMPDIR}

ess :
	@echo ----- Making ESS...
	TMPDIR=${TMP} ${MAKE} EMACS=${EMACS} -C ${ESS} all
	${MAKE} DESTDIR=${DESTDIR} SITELISP=${SITELISP} \
	        ETCDIR=${ETCDIR}/ess DOCDIR=${DOCDIR}/ess \
	        INFODIR=${INFODIR} -C ${ESS} install
	if [ -f ${SITELISP}/ess-site.el ]; then rm ${SITELISP}/ess-site.el; fi
	@echo ----- Done making ESS

auctex :
	@echo ----- Making AUCTeX...
	cd ${AUCTEX} && ./configure --prefix=${PREFIX} \
		--without-texmf-dir \
		--with-emacs=${EMACS}
	make -C ${AUCTEX}
	make -C ${AUCTEX} install
	mv ${SITELISP}/auctex/doc/preview.* ${DOCDIR}/auctex
	rmdir ${SITELISP}/auctex/doc
	@echo ----- Done making AUCTeX

org :
	@echo ----- Making org...
	${MAKE} EMACS=${EMACS} -C ${ORG} all
	${MAKE} EMACS=${EMACS} lispdir=${SITELISP}/org \
	        datadir=${ETCDIR}/org infodir=${INFODIR} -C ${ORG} install
	mkdir -p ${DOCDIR}/org && cp -p ${ORG}/doc/*.html ${DOCDIR}/org/
	@echo ----- Done making org

polymode :
	@echo ----- copying markdown-mode and polymode files...
	cp -p markdown-mode.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/markdown-mode.el
	mkdir -p ${SITELISP}/polymode
	cp -p polymode/*.el ${SITELISP}/polymode
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/polymode/*.el
	mkdir -p ${DOCDIR}/polymode
	cp -p polymode/*.md ${DOCDIR}/polymode
	@echo ----- Done installing polymode

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


