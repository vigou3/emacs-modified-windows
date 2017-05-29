### -*-Makefile-*- to build Emacs Modified for Windows
##
## Copyright (C) 2014-2017 Vincent Goulet
##
## The code of this Makefile is based on a file created by Remko
## Troncon (http://el-tramo.be/about).
##
## Author: Vincent Goulet
##
## This file is part of Emacs Modified for Windows
## http://vigou3.github.io/emacs-modified-windows

## Set most variables in Makeconf
include ./Makeconf

## Build directory et al.
TMPDIR = ${CURDIR}/tmpdir

## Emacs specific info
PREFIX = ${TMPDIR}/emacs-bin
EMACS = ${PREFIX}/bin/emacs.exe
EMACSBATCH = $(EMACS) -batch -no-site-file -no-init-file

## Inno Setup info
INNOSCRIPT = emacs-modified.iss
INNOSETUP = c:/progra~1/innose~1/iscc.exe
INFOBEFOREFR = InfoBefore-fr.txt
INFOBEFOREEN = InfoBefore-en.txt

## Override of ESS variables
DESTDIR = ${PREFIX}/share/
SITELISP = ${DESTDIR}/emacs/site-lisp
ETCDIR = ${DESTDIR}/emacs/etc
DOCDIR = ${DESTDIR}/doc
INFODIR = ${DESTDIR}/info

## Base name of extensions
ESS = ess-${ESSVERSION}
AUCTEX = auctex-${AUCTEXVERSION}
ORG = org-${ORGVERSION}
POLYMODE = polymode-master
LIBPNG = libpng-${LIBPNGVERSION}-w32-bin
ZLIB = zlib-${ZLIBVERSION}-w32-bin
JPEG = jpeg-${JPEGVERSION}-w32-bin
TIFF = tiff-${TIFFVERSION}-w32-bin
GIFLIB = giflib-${GIFLIBVERSION}-w32-bin
LIBRSVG = librsvg-${LIBRSVGVERSION}-w32-bin
GNUTLS = gnutls-${GNUTLSVERSION}-w32-bin
LIBS = libs

## Toolset
CP = cp -p
RM = rm -r

all : get-packages emacs release

get-packages : get-emacs get-ess get-auctex get-org get-polymode get-markdownmode get-psvn get-libs

emacs : dir libs ess auctex org polymode markdownmode psvn exe

release : create-release upload publish

.PHONY : emacs dir libs ess auctex org polymode psvn exe release create-release upload publish clean

dir :
	@echo ----- Creating the application in temporary directory...
	if [ -d ${TMPDIR} ]; then rm -rf ${TMPDIR}; fi
	mkdir -p ${PREFIX}
	unzip -q ${ZIPFILE} -d ${PREFIX}
	cp -dpr aspell ${PREFIX}
	${CP} default.el ${SITELISP}/
	sed '/^(defconst/s/\(emacs-modified-version '"'"'\)[0-9]\+/\1${DISTVERSION}/' \
	    version-modified.el > tmpfile && \
	    mv tmpfile version-modified.el && \
	  ${CP} version-modified.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/version-modified.el
	${CP} framepop.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/framepop.el
	${CP} w32-winprint.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/w32-winprint.el
	${CP} htmlize.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/htmlize.el
	${CP} htmlize-view.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/htmlize-view.el
	sed -e '/^AppVerName/s/\(Emacs \)[0-9.]\+-modified-[0-9]\+/\1${VERSION}/' \
	    -e '/^AppId/s/\(GNUEmacs\)[0-9.]\+-modified-[0-9]\+/\1${VERSION}/' \
	    -e '/^DefaultDirName/s/\(GNU Emacs \)[0-9.]\+/\1${EMACSVERSION}/' \
	    -e '/^DefaultGroupName/s/\(GNU Emacs \)[0-9.]\+/\1${EMACSVERSION}/' \
	    -e '/^OutputBaseFilename/s/\(emacs-\)[0-9.]\+-modified-[0-9]\+/\1${VERSION}/' \
	    -e 's/\(\\emacs\\\)[0-9.]\+/\1${EMACSVERSION}/' \
	    ${INNOSCRIPT} > tmpfile && \
	    mv tmpfile ${INNOSCRIPT} && \
	  ${CP} ${INNOSCRIPT} ${TMPDIR}/
	sed -e 's/[0-9.]\+-modified-[0-9]\+/${VERSION}/' \
	    -e 's/\(ESS \)[0-9.]\+/\1${ESSVERSION}/' \
	    -e 's/\(AUCTeX \)[0-9.]\+/\1${AUCTEXVERSION}/' \
	    -e 's/\(org \)[0-9.]\+/\1${ORGVERSION}/' \
	    -e 's/\(polymode \)[0-9\-]\+/\1${POLYMODEVERSION}/' \
	    -e 's/\(markdown-mode.el \)[0-9.]\+/\1${MARKDOWNMODEVERSION}/' \
	    -e 's/\(psvn.el \)[0-9]\+/\1${PSVNVERSION}/' \
	    -e 's/\(PNG \)[0-9.]\+/\1${LIBPNGVERSION}/' \
	    -e 's/\(JPEG \)v[0-9]\+[a-z]/\1${JPEGVERSION}/' \
	    -e 's/\(TIFF \)[0-9.]\+/\1${TIFFVERSION}/' \
	    -e 's/\(GIF \)[0-9.]\+/\1${GIFLIBVERSION}/' \
	    -e 's/\(SVG \)[0-9.\-]\+/\1${LIBRSVGVERSION}/' \
	    -e 's/\(zlib \)[0-9.\-]\+/\1${ZLIBVERSION}/' \
	    -e 's/\(GnuTLS \)[0-9.]\+/\1${GNUTLSVERSION}/' \
	    README-modified.txt > tmpfile && \
	    mv tmpfile README-modified.txt && \
	  ${CP} README-modified.txt ${TMPDIR}/
	${CP} site-start.el NEWS ${TMPDIR}

libs :
	@echo ----- Copying image libraries...
	if [ -d ${LIBS} ]; then rm -rf ${LIBS}; fi
	unzip -j ${LIBPNG}.zip bin/libpng16-16.dll -d ${LIBS}
	unzip -j ${ZLIB}.zip bin/zlib1.dll -d ${LIBS}
	unzip -j ${JPEG}.zip bin/libjpeg-8.dll -d ${LIBS}
	unzip -j ${TIFF}.zip bin/libtiff-5.dll -d ${LIBS}
	unzip -j ${GIFLIB}.zip bin/libgif-7.dll -d ${LIBS}
	unzip -j ${LIBRSVG}.zip bin/*.dll -x bin/zlib1.dll \
	         bin/libiconv-*.dll bin/libintl-*.dll bin/libpng*.dll -d ${LIBS}
	unzip -j ${GNUTLS}.zip bin/*.dll -x bin/zlib1.dll -d ${LIBS}
	${CP} ${LIBS}/* ${PREFIX}/bin
	rm -rf ${LIBS}
	@echo ----- Done copying the libraries

ess :
	@echo ----- Making ESS...
	if [ -d ${ESS} ]; then rm -rf ${ESS}; fi
	unzip ${ESS}.zip
	TMPDIR=${TMP} ${MAKE} EMACS=${EMACS} -C ${ESS} all
	${MAKE} DESTDIR=${DESTDIR} SITELISP=${SITELISP} \
	        ETCDIR=${ETCDIR}/ess DOCDIR=${DOCDIR}/ess \
	        INFODIR=${INFODIR} -C ${ESS} install
	if [ -f ${SITELISP}/ess-site.el ]; then rm ${SITELISP}/ess-site.el; fi
	rm -rf ${ESS}
	@echo ----- Done making ESS

auctex :
	@echo ----- Making AUCTeX...
	if [ -d ${AUCTEX} ]; then rm -rf ${AUCTEX}; fi
	unzip ${AUCTEX}.zip
	cd ${AUCTEX} && ./configure --prefix=${PREFIX} \
		--without-texmf-dir \
		--with-emacs=${EMACS}
	make -C ${AUCTEX}
	make -C ${AUCTEX} install
	mv ${SITELISP}/auctex/doc/preview.* ${DOCDIR}/auctex
	rmdir ${SITELISP}/auctex/doc
	rm -rf ${AUCTEX}
	@echo ----- Done making AUCTeX

org :
	@echo ----- Making org...
	if [ -d ${ORG} ]; then rm -rf ${ORG}; fi
	unzip ${ORG}.zip
	${MAKE} EMACS=${EMACS} -C ${ORG} all
	${MAKE} EMACS=${EMACS} lispdir=${SITELISP}/org \
	        datadir=${ETCDIR}/org infodir=${INFODIR} -C ${ORG} install
	mkdir -p ${DOCDIR}/org && ${CP} ${ORG}/doc/*.html ${DOCDIR}/org/
	rm -rf ${ORG}
	@echo ----- Done making org

polymode :
	@echo ----- Copying and byte compiling polymode files...
	if [ -d ${POLYMODE} ]; then rm -rf ${POLYMODE}; fi
	unzip ${POLYMODE}.zip
	mkdir -p ${SITELISP}/polymode ${DOCDIR}/polymode
	${CP} ${POLYMODE}/*.el ${POLYMODE}/modes/*.el ${SITELISP}/polymode
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/polymode/*.el
	${CP} ${POLYMODE}/readme.md ${DOCDIR}/polymode
	${CP} ${POLYMODE}/modes/readme.md ${DOCDIR}/polymode/developing.md
	rm -rf ${POLYMODE}
	@echo ----- Done installing polymode

markdownmode :
	@echo ----- Copying and byte compiling markdown-mode.el...
	${CP} markdown-mode.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/markdown-mode.el
	@echo ----- Done installing markdown-mode.el

psvn :
	@echo ----- Patching and byte compiling psvn.el...
	patch -o ${SITELISP}/psvn.el psvn.el psvn.el_svn1.7.diff
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/psvn.el
	@echo ----- Done installing psvn.el

exe :
	@echo ----- Building the archive...
	cd ${TMPDIR}/ && cmd /c "${INNOSETUP} ${INNOSCRIPT}"
	rm -rf ${TMPDIR}
	@echo ----- Done building the archive

create-release :
	@echo ----- Creating release on GitHub...
	if [ -e relnotes.in ]; then rm relnotes.in; fi
	git commit -a -m "Version ${VERSION}" && git push
	awk 'BEGIN { ORS=" "; print "{\"tag_name\": \"v${VERSION}\"," } \
	      /^$$/ { next } \
              (state==0) && /^# / { state=1; \
	                            print "\"name\": \"Emacs Modified for Windows ${VERSION}\", \"body\": \""; \
	                             next } \
	      (state==1) && /^# / { state=2; print "\","; next } \
	      state==1 { printf "%s\\n", $$0 } \
	      END { print "\"draft\": false, \"prerelease\": false}" }' \
	      NEWS > relnotes.in
	curl --data @relnotes.in ${REPOSURL}/releases?access_token=${OAUTHTOKEN}
	rm relnotes.in
	@echo ----- Done creating the release

upload :
	@echo ----- Getting upload URL from GitHub...
	$(eval upload_url=$(shell curl -s ${REPOSURL}/releases/latest \
	 			  | awk -F '[ {]' '/^  \"upload_url\"/ \
	                                    { print substr($$4, 2, length) }'))
	@echo ${upload_url}
	@echo ----- Uploading the installer to GitHub...
	curl -H 'Content-Type: application/zip' \
	     -H 'Authorization: token ${OAUTHTOKEN}' \
	     --upload-file emacs-${VERSION}.exe \
	     -s -i "${upload_url}?&name=emacs-${VERSION}.exe"
	@echo ----- Done uploading the installer

publish :
	@echo ----- Publishing the web page...
	${MAKE} -C docs
	@echo ----- Done publishing

get-emacs :
	@echo ----- Fetching and unpacking Emacs...
	if [ -f ${ZIPFILE} ]; then rm ${ZIPFILE}; fi
	curl -O ftp://ftp.gnu.org/gnu/emacs/windows/${ZIPFILE}

get-ess :
	@echo ----- Fetching ESS...
	if [ -d ${ESS}.zip ]; then rm ${ESS}.zip; fi
	curl -O http://ess.r-project.org/downloads/ess/${ESS}.zip

get-auctex :
	@echo ----- Fetching AUCTeX...
	if [ -f ${AUCTEX}.zip ]; then rm ${AUCTEX}.zip; fi
	curl -O http://ftp.gnu.org/pub/gnu/auctex/${AUCTEX}.zip

get-org :
	@echo ----- Fetching org...
	if [ -f ${ORG}.zip ]; then rm ${ORG}.zip; fi
	curl -O http://orgmode.org/${ORG}.zip

get-polymode :
	@echo ----- Fetching polymode
	if [ -f ${POLYMODE}.zip ]; then rm ${POLYMODE}.zip; fi
	curl -L -o ${POLYMODE}.zip https://github.com/vspinu/polymode/archive/master.zip

get-markdownmode :
	@echo ----- Fetching markdown-mode.el
	if [ -f markdown-mode.el ]; then rm markdown-mode.el; fi
	curl -OL https://github.com/jrblevin/markdown-mode/raw/v${MARKDOWNMODEVERSION}/markdown-mode.el

get-psvn :
	@echo ----- Fetching psvn.el
	if [ -f psvn.el ]; then rm psvn.el; fi
	svn cat http://svn.apache.org/repos/asf/subversion/trunk/contrib/client-side/emacs/psvn.el > psvn.el && flip -u psvn.el

get-libs :
	@echo ----- Preparing library files
	rm -rf lib
	curl -OL https://sourceforge.net/projects/ezwinports/files/${LIBPNG}.zip
	curl -OL https://sourceforge.net/projects/ezwinports/files/${ZLIB}.zip
	curl -OL https://sourceforge.net/projects/ezwinports/files/${JPEG}.zip
	curl -OL https://sourceforge.net/projects/ezwinports/files/${TIFF}.zip
	curl -OL https://sourceforge.net/projects/ezwinports/files/${GIFLIB}.zip
	curl -OL https://sourceforge.net/projects/ezwinports/files/${LIBRSVG}.zip
	curl -OL https://sourceforge.net/projects/ezwinports/files/${GNUTLS}.zip

clean :
	${RM} ${TMPDIR}
	cd ${ESS} && ${MAKE} clean
	cd ${AUCTEX} && ${MAKE} clean
