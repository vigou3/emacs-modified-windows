### -*-Makefile-*- for GitHub page of GNU Emacs Modified for Windows
##
## Copyright (C) 2014-2017 Vincent Goulet
##
## The code of this Makefile is based on a file created by Remko
## Troncon (http://el-tramo.be/about).
##
## Author: Vincent Goulet
##
## This file is part of GNU Emacs Modified for Windows
## http://github.com/vigou3/emacs-modified-windows

## Set most variables in Makeconf
include ./Makeconf

## Build directory et al.
TMPDIR=${CURDIR}/tmpdir

## Emacs specific info
PREFIX=${TMPDIR}/emacs-bin
EMACS=${PREFIX}/bin/emacs.exe
EMACSBATCH = $(EMACS) -batch -no-site-file -no-init-file

## Inno Setup info
INNOSCRIPT=emacs-modified.iss
INNOSETUP=c:/progra~1/innose~1/iscc.exe
INFOBEFOREFR=InfoBefore-fr.txt
INFOBEFOREEN=InfoBefore-en.txt

## Override of ESS variables
DESTDIR=${PREFIX}/share/
SITELISP=${DESTDIR}/emacs/site-lisp
ETCDIR=${DESTDIR}/emacs/etc
DOCDIR=${DESTDIR}/doc
INFODIR=${DESTDIR}/info

## Base name of extensions
ESS=ess-${ESSVERSION}
AUCTEX=auctex-${AUCTEXVERSION}
ORG=org-${ORGVERSION}
POLYMODE=polymode-master
LIBPNG=libpng-${LIBPNGVERSION}-w32-bin
ZLIB=zlib-${ZLIBVERSION}-w32-bin
JPEG=jpeg-${JPEGVERSION}-w32-bin
TIFF=tiff-${TIFFVERSION}-w32-bin
GIFLIB=giflib-${GIFLIBVERSION}-w32-bin
LIBRSVG=librsvg-${LIBRSVGVERSION}-w32-bin
GNUTLS=gnutls-${GNUTLSVERSION}-w32-bin
LIBS=libs

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
	cp -p default.el ${SITELISP}/
	sed -e '/^(defconst/s/<DISTVERSION>/${DISTVERSION}/' \
	    version-modified.el.in > ${SITELISP}/version-modified.el
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
	    ${INNOSCRIPT}.in > ${TMPDIR}/${INNOSCRIPT}
	sed -e 's/<VERSION>/${VERSION}/' \
	    -e 's/<ESSVERSION>/${ESSVERSION}/' \
	    -e 's/<AUCTEXVERSION>/${AUCTEXVERSION}/' \
	    -e 's/<ORGVERSION>/${ORGVERSION}/' \
	    -e 's/<POLYMODEVERSION>/${POLYMODEVERSION}/' \
	    -e 's/<MARKDOWNMODEVERSION>/${MARKDOWNMODEVERSION}/' \
	    -e 's/<PSVNVERSION>/${PSVNVERSION}/' \
	    -e 's/<LIBPNGVERSION>/${LIBPNGVERSION}/' \
	    -e 's/<ZLIBVERSION>/${ZLIBVERSION}/' \
	    -e 's/<JPEGVERSION>/${JPEGVERSION}/' \
	    -e 's/<TIFFVERSION>/${TIFFVERSION}/' \
	    -e 's/<GIFLIBVERSION>/${GIFLIBVERSION}/' \
	    -e 's/<LIBRSVGVERSION>/${LIBRSVGVERSION}/' \
	    -e 's/<GNUTLSVERSION>/${GNUTLSVERSION}/' \
		    README-Modified.txt.in > ${TMPDIR}/README-Modified.txt
	cp -p site-start.el NEWS ${TMPDIR}

libs :
	@echo ----- Copying image libraries...
	if [ -d ${LIBS} ]; then rm -rf ${LIBS}; fi
	unzip -j ${LIBPNG}.zip bin/libpng16-16.dll -d ${LIBS}
	unzip -j ${ZLIB}.zip bin/zlib1.dll -d ${LIBS}
	unzip -j ${JPEG}.zip bin/libjpeg-9.dll -d ${LIBS}
	unzip -j ${TIFF}.zip bin/libtiff-5.dll -d ${LIBS}
	unzip -j ${GIFLIB}.zip bin/libgif-7.dll -d ${LIBS}
	unzip -j ${LIBRSVG}.zip bin/*.dll -x bin/zlib1.dll \
	         bin/libiconv-*.dll bin/libintl-*.dll bin/libpng*.dll -d ${LIBS}
	unzip -j ${GNUTLS}.zip bin/*.dll -x bin/zlib1.dll -d ${LIBS}
	cp -p ${LIBS}/* ${PREFIX}/bin
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
	mkdir -p ${DOCDIR}/org && cp -p ${ORG}/doc/*.html ${DOCDIR}/org/
	rm -rf ${ORG}
	@echo ----- Done making org

polymode :
	@echo ----- Copying and byte compiling polymode files...
	if [ -d ${POLYMODE} ]; then rm -rf ${POLYMODE}; fi
	unzip ${POLYMODE}.zip
	mkdir -p ${SITELISP}/polymode ${DOCDIR}/polymode
	cp -p ${POLYMODE}/*.el ${POLYMODE}/modes/*.el ${SITELISP}/polymode
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/polymode/*.el
	cp -p ${POLYMODE}/readme.md ${DOCDIR}/polymode
	cp -p ${POLYMODE}/modes/readme.md ${DOCDIR}/polymode/developing.md
	rm -rf ${POLYMODE}
	@echo ----- Done installing polymode

markdownmode :
	@echo ----- Copying and byte compiling markdown-mode.el...
	cp -p markdown-mode.el ${SITELISP}/
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
	     --upload-file ${DISTNAME}.exe \
	     -s -i "${upload_url}?&name=${DISTNAME}.exe"
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
	rm -rf ${TMPDIR}
	cd ${ESS} && ${MAKE} clean
	cd ${AUCTEX} && ${MAKE} clean


