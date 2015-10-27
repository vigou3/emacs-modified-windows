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

PREFIX=${TMPDIR}/emacs-bin
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

all : get-packages emacs

.PHONY : emacs dir ess auctex org polymode psvn exe www clean

emacs : dir ess auctex org polymode markdownmode psvn exe

get-packages : get-ess get-auctex get-org get-polymode get-markdownmode get-psvn

dir :
	@echo ----- Creating the application in temporary directory...
	if [ -d ${TMPDIR} ]; then rm -rf ${TMPDIR}; fi
	mkdir -p ${PREFIX}
	unzip -q ${ZIPFILE} -d ${PREFIX}
	cp -p lib/* ${PREFIX}/bin
	cp -dpr aspell ${PREFIX}
	cp -p default.el ${SITELISP}/
	sed -e '/^(defconst/s/<DISTVERSION>/${DISTVERSION}/' \
	    version-modified.el.in > version-modified.el
	cp -p version-modified.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/version-modified.el
	cp -p framepop.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/framepop.el
	cp -p w32-winprint.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/w32-winprint.el
	cp -p htmlize.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/htmlize.el
	cp -p htmlize-view.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/htmlize-view.el
	sed -e 's/<VERSION>/${VERSION}/' \
	    -e 's/<EMACSVERSION>/${EMACSVERSION}/' \
	    -e 's/<DISTNAME>/${DISTNAME}/' \
	    ${INNOSCRIPT}.in > ${INNOSCRIPT}
	sed -e 's/<VERSION>/${VERSION}/' \
	    -e 's/<ESSVERSION>/${ESSVERSION}/' \
	    -e 's/<AUCTEXVERSION>/${AUCTEXVERSION}/' \
	    -e 's/<ORGVERSION>/${ORGVERSION}/' \
	    -e 's/<POLYMODEVERSION>/${POLYMODEVERSION}/' \
	    -e 's/<MARKDOWNMODEVERSION>/${MARKDOWNMODEVERSION}/' \
	    -e 's/<PSVNVERSION>/${PSVNVERSION}/' \
	    -e 's/<LIBPNGVERSION>/${LIBPNGVERSION}/' \
	    -e 's/<LIBZLIBVERSION>/${LIBZLIBVERSION}/' \
	    -e 's/<LIBJPEGVERSION>/${LIBJPEGVERSION}/' \
	    -e 's/<LIBTIFFVERSION>/${LIBTIFFVERSION}/' \
	    -e 's/<LIBGIFVERSION>/${LIBGIFVERSION}/' \
	    -e 's/<LIBGNUTLSVERSION>/${LIBGNUTLSVERSION}/' \
		    README-Modified.txt.in > README-Modified.txt
	cp -p site-start.el README-Modified.txt NEWS ${INNOSCRIPT} ${TMPDIR}

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
	@echo ----- Copying polymode files...
	mkdir -p ${SITELISP}/polymode
	cp -p polymode/*.el ${SITELISP}/polymode
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/polymode/*.el
	mkdir -p ${DOCDIR}/polymode
	cp -p polymode/*.md ${DOCDIR}/polymode
	@echo ----- Done installing polymode

markdownmode :
	@echo ----- Copying markdown-mode.el...
	cp -p markdown-mode.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/markdown-mode.el
	@echo ----- Done installing markdown-mode.el

psvn :
	@echo ----- Copying psvn.el...
	cp -p psvn.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/psvn.el
	@echo ----- Done copying installing psvn.el

exe :
	@echo ----- Building the archive...
	cd ${TMPDIR}/ && cmd /c "${INNOSETUP} ${INNOSCRIPT}"
	rm -rf ${TMPDIR}
	@echo ----- Done building the archive

www : www-files www-pages

www-files :
	@echo ----- Pushing files to web site...
	cp -p ${DISTNAME}.exe ${WWWLIVE}/htdocs/pub/emacs/
	cp -p NEWS ${WWWLIVE}/htdocs/pub/emacs/NEWS-windows
	@echo ----- Done copying files

www-pages :
	@echo ----- Updating web pages...
	cd ${WWWSRC} && svn update
	cd ${WWWSRC}/htdocs/s/emacs/ &&                       \
		sed -e 's/<ESSVERSION>/${ESSVERSION}/'       \
		    -e 's/<AUCTEXVERSION>/${AUCTEXVERSION}/' \
		    -e 's/<ORGVERSION>/${ORGVERSION}/'     \
		    -e 's/<PSVNVERSION>/${PSVNVERSION}/'     \
		    -e 's/<VERSION>/${VERSION}/'             \
		    -e 's/<DISTNAME>/${DISTNAME}/g'           \
		    -e 's/<LIBPNGVERSION>/${LIBPNGVERSION}/' \
		    -e 's/<LIBZLIBVERSION>/${LIBZLIBVERSION}/' \
		    -e 's/<LIBJPEGVERSION>/${LIBJPEGVERSION}/' \
		    -e 's/<LIBTIFFVERSION>/${LIBTIFFVERSION}/' \
		    -e 's/<LIBGIFVERSION>/${LIBGIFVERSION}/' \
		    -e 's/<LIBGNUTLSVERSION>/${LIBGNUTLSVERSION}/' \
		    windows.html.in > windows.html
	cp -p ${WWWSRC}/htdocs/s/emacs/windows.html ${WWWLIVE}/htdocs/s/emacs/
	cd ${WWWSRC}/htdocs/en/s/emacs/ &&                    \
		sed -e 's/<ESSVERSION>/${ESSVERSION}/'       \
		    -e 's/<AUCTEXVERSION>/${AUCTEXVERSION}/' \
		    -e 's/<ORGVERSION>/${ORGVERSION}/'     \
		    -e 's/<PSVNVERSION>/${PSVNVERSION}/'     \
		    -e 's/<VERSION>/${VERSION}/'             \
		    -e 's/<DISTNAME>/${DISTNAME}/g'           \
		    -e 's/<LIBPNGVERSION>/${LIBPNGVERSION}/' \
		    -e 's/<LIBZLIBVERSION>/${LIBZLIBVERSION}/' \
		    -e 's/<LIBJPEGVERSION>/${LIBJPEGVERSION}/' \
		    -e 's/<LIBTIFFVERSION>/${LIBTIFFVERSION}/' \
		    -e 's/<LIBGIFVERSION>/${LIBGIFVERSION}/' \
		    -e 's/<LIBGNUTLSVERSION>/${LIBGNUTLSVERSION}/' \
		    windows.html.in > windows.html
	cp -p ${WWWSRC}/htdocs/en/s/emacs/windows.html ${WWWLIVE}/htdocs/en/s/emacs/
	cd ${WWWLIVE} && ls -lRa > ${WWWSRC}/ls-lRa
	cd ${WWWSRC} && svn ci -m "Update for Emacs Modified for Windows version ${VERSION}"
	svn ci -m "Version ${VERSION}"
	svn cp ${REPOS}/trunk ${REPOS}/tags/${DISTNAME} -m "Tag version ${VERSION}"
	@echo ----- Done updating web pages

get-ess :
	@echo ----- Fetching and unpacking ESS...
	rm -rf ${ESS}
	wget http://ess.r-project.org/downloads/ess/${ESS}.zip && unzip ${ESS}.zip

get-auctex :
	@echo ----- Fetching and unpacking AUCTeX...
	rm -rf ${AUCTEX}
	wget http://ftp.gnu.org/pub/gnu/auctex/${AUCTEX}.zip && unzip ${AUCTEX}.zip

get-org :
	@echo ----- Fetching and unpacking org...
	rm -rf ${ORG}
	wget http://orgmode.org/${ORG}.zip && unzip ${ORG}.zip

get-polymode :
	@echo ----- Preparing polymode
	rm -rf polymode
	git -C ../polymode pull
	mkdir polymode && \
		cp -p ../polymode/*.el ../polymode/modes/*.el ../polymode/readme.md polymode && \
		cp -p ../polymode/modes/readme.md polymode/developing.md

get-markdownmode :
	@echo ----- Preparing markdown-mode
	git -C ../markdown-mode pull
	cp -p ../markdown-mode/markdown-mode.el .

get-psvn :
	@echo ----- Preparing psvn.el
	svn update ../emacs-svn
	cp -p ../emacs-svn/psvn.el .

get-libs :
	@echo ----- Preparing library files
	wget http://sourceforge.net/projects/ezwinports/files/${LIBPNGVERSION}-w32-bin.zip && \
	unzip -j ${LIBPNGVERSION}-w32-bin.zip bin/libpng16-16.dll -d lib/
	wget http://sourceforge.net/projects/ezwinports/files/${LIBZLIBVERSION}-w32-bin.zip && \
	unzip -j ${LIBZLIBVERSION}-w32-bin.zip bin/zlib1.dll -d lib/
	wget http://sourceforge.net/projects/ezwinports/files/${LIBJPEGVERSION}-w32-bin.zip && \
	unzip -j ${LIBJPEGVERSION}-w32-bin.zip bin/libjpeg-9.dll -d lib/
	wget http://sourceforge.net/projects/ezwinports/files/${LIBTIFFVERSION}-w32-bin.zip && \
	unzip -j ${LIBTIFFVERSION}-w32-bin.zip bin/libtiff-5.dll -d lib/
	wget http://sourceforge.net/projects/ezwinports/files/${LIBGIFVERSION}-w32-bin.zip && \
	unzip -j ${LIBGIFVERSION}-w32-bin.zip bin/libgif-7.dll -d lib/
	wget http://sourceforge.net/projects/ezwinports/files/${LIBGNUTLSVERSION}-w32-bin.zip && \
	unzip -j ${LIBGNUTLSVERSION}-w32-bin.zip bin/*.dll -x bin/zlib1.dll -d lib/

clean :
	rm -rf ${TMPDIR}
	cd ${ESS} && ${MAKE} clean
	cd ${AUCTEX} && ${MAKE} clean


