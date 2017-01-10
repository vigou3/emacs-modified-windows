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

## Directories of extensions
ESS=ess-${ESSVERSION}
AUCTEX=auctex-${AUCTEXVERSION}
ORG=org-${ORGVERSION}

all : get-packages emacs release

get-packages : get-emacs get-ess get-auctex get-org get-polymode get-markdownmode get-psvn get-libs

emacs : dir ess auctex org polymode markdownmode psvn exe

release : create-release upload publish

.PHONY : emacs dir ess auctex org polymode psvn exe release create-release upload publish clean

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
	    -e 's/<LIBSVGVERSION>/${LIBSVGVERSION}/' \
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
	@echo ----- Copying and byte compiling polymode files...
	mkdir -p ${SITELISP}/polymode ${DOCDIR}/polymode
	cp -p polymode/*.el polymode/modes/*.el ${SITELISP}/polymode
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/polymode/*.el
	cp -p polymode/readme.md ${DOCDIR}/polymode
	cp -p polymode/modes/readme.md ${DOCDIR}/polymode/developing.md
	@echo ----- Done installing polymode

markdownmode :
	@echo ----- Copying and byte compiling markdown-mode.el...
	cp -p markdown-mode/markdown-mode.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/markdown-mode.el
	@echo ----- Done installing markdown-mode.el

psvn :
	@echo ----- Patching and byte compiling psvn.el...
	patch -o ${SITELISP}/psvn.el emacs-svn/psvn.el psvn.el_svn1.7.diff
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/psvn.el
	@echo ----- Done copying installing psvn.el

exe :
	@echo ----- Building the archive...
	cd ${TMPDIR}/ && cmd /c "${INNOSETUP} ${INNOSCRIPT}"
	rm -rf ${TMPDIR}
	@echo ----- Done building the archive

create-release :
	@echo ----- Creating release on GitHub...
	if [ -e relnotes.in ]; then rm relnotes.in; fi
	git commit -a -m "Version ${VERSION}" && git push
	@echo '{"tag_name": "v${VERSION}",' > relnotes.in
	@echo ' "name": "GNU Emacs Modified for Windows ${VERSION}",' >> relnotes.in
	@echo '"body": "' >> relnotes.in
	@awk '/${VERSION}/{flag=1; next} /^Version/{flag=0} flag' NEWS \
	     | tail +3 | tail -r | tail +3 | tail -r | sed 's|$$|\\n|' >> relnotes.in
	@echo '", "draft": false, "prerelease": false}' >> relnotes.in
	curl --data @relnotes.in ${REPOSURL}/releases?access_token=${OAUTHTOKEN}
	rm relnotes.in
	@echo ----- Done creating the release

upload : 
	@echo ----- Getting upload URL from GitHub...
	$(eval upload_url=$(shell curl -s ${REPOSURL}/releases/latest \
	 			  | grep "^  \"upload_url\""  \
	 			  | cut -d \" -f 4            \
	 			  | cut -d { -f 1))
	@echo ${upload_url}
	@echo ----- Uploading the installer to GitHub...
	curl -H 'Content-Type: application/zip' \
	     -H 'Authorization: token ${OAUTHTOKEN}' \
	     --upload-file ${DISTNAME}.exe \
             -s -i "${upload_url}?&name=${DISTNAME}.exe"
	@echo ----- Done uploading the installer

publish :
	@echo ----- Publishing the web page...
	git checkout gh-pages && \
	${MAKE} \
	  VERSION=${VERSION} \
	  ESSVERSION=${ESSVERSION} \
	  AUCTEXVERSION=${AUCTEXVERSION} \
	  ORGVERSION=${ORGVERSION} \
	  POLYMODEVERSION=${POLYMODEVERSION} \
	  MARDOWNMODEVERSION=${MARDOWNMODEVERSION} \
	  PSVNVERSION=${PSVNVERSION} \
	  LIBPNGVERSION=${LIBPNGVERSION} \
	  LIBZLIBVERSION=${LIBZLIBVERSION} \
	  LIBJPEGVERSION=${LIBJPEGVERSION} \
	  LIBTIFFVERSION=${LIBTIFFVERSION} \
	  LIBGIFVERSION=${LIBGIFVERSION} \
	  LIBSVGVERSION=${LIBSVGVERSION} \
	  LIBGNUTLSVERSION=${LIBGNUTLSVERSION} \
	  DISTNAME=${DISTNAME} && \
	git checkout master

get-emacs :
	@echo ----- Fetching and unpacking Emacs...
	rm -rf ${ZIPFILE}
	wget -nc ftp://ftp.gnu.org/gnu/emacs/windows/${ZIPFILE}

get-ess :
	@echo ----- Fetching and unpacking ESS...
	rm -rf ${ESS}
	wget -nc http://ess.r-project.org/downloads/ess/${ESS}.zip && unzip ${ESS}.zip

get-auctex :
	@echo ----- Fetching and unpacking AUCTeX...
	rm -rf ${AUCTEX}
	wget -nc http://ftp.gnu.org/pub/gnu/auctex/${AUCTEX}.zip && unzip ${AUCTEX}.zip

get-org :
	@echo ----- Fetching and unpacking org...
	rm -rf ${ORG}
	wget -nc http://orgmode.org/${ORG}.zip && unzip ${ORG}.zip

get-polymode :
	@echo ----- Preparing polymode
	git submodule update --remote markdown-mode

get-markdownmode :
	@echo ----- Preparing markdown-mode
	git submodule update --remote markdown-mode

get-psvn :
	@echo ----- Preparing psvn.el
	svn update emacs-svn

get-libs :
	@echo ----- Preparing library files
	rm -rf lib
	wget -nc --no-check-certificate https://sourceforge.net/projects/ezwinports/files/${LIBPNGVERSION}-w32-bin.zip && \
	unzip -j ${LIBPNGVERSION}-w32-bin.zip bin/libpng16-16.dll -d lib/
	wget -nc --no-check-certificate https://sourceforge.net/projects/ezwinports/files/${LIBZLIBVERSION}-w32-bin.zip && \
	unzip -j ${LIBZLIBVERSION}-w32-bin.zip bin/zlib1.dll -d lib/
	wget -nc --no-check-certificate https://sourceforge.net/projects/ezwinports/files/${LIBJPEGVERSION}-w32-bin.zip && \
	unzip -j ${LIBJPEGVERSION}-w32-bin.zip bin/libjpeg-9.dll -d lib/
	wget -nc --no-check-certificate https://sourceforge.net/projects/ezwinports/files/${LIBTIFFVERSION}-w32-bin.zip && \
	unzip -j ${LIBTIFFVERSION}-w32-bin.zip bin/libtiff-5.dll -d lib/
	wget -nc --no-check-certificate https://sourceforge.net/projects/ezwinports/files/${LIBGIFVERSION}-w32-bin.zip && \
	unzip -j ${LIBGIFVERSION}-w32-bin.zip bin/libgif-7.dll -d lib/
	wget -nc --no-check-certificate https://sourceforge.net/projects/ezwinports/files/${LIBSVGVERSION}-w32-bin.zip && \
	unzip -j ${LIBSVGVERSION}-w32-bin.zip bin/*.dll -x bin/zlib1.dll bin/libiconv-*.dll bin/libintl-*.dll bin/libpng*.dll -d lib/
	wget -nc --no-check-certificate https://sourceforge.net/projects/ezwinports/files/${LIBGNUTLSVERSION}-w32-bin.zip && \
	unzip -j ${LIBGNUTLSVERSION}-w32-bin.zip bin/*.dll -x bin/zlib1.dll -d lib/

clean :
	rm -rf ${TMPDIR}
	cd ${ESS} && ${MAKE} clean
	cd ${AUCTEX} && ${MAKE} clean


