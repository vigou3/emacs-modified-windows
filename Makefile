### -*-Makefile-*- to build Emacs Modified for Windows
##
## Copyright (C) 2014-2018 Vincent Goulet
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
PREFIX = ${TMPDIR}/emacs
EMACS = ${PREFIX}/bin/emacs.exe
EMACSBATCH = $(EMACS) -batch -no-site-file -no-init-file

## Inno Setup info
INNOSCRIPT = emacs-modified.iss
INNOSETUP = c:/progra~2/innose~1/iscc.exe
INFOBEFOREFR = InfoBefore-fr.txt
INFOBEFOREEN = InfoBefore-en.txt

## Override of ESS variables
DESTDIR = ${PREFIX}/share
SITELISP = ${DESTDIR}/emacs/site-lisp
ETCDIR = ${DESTDIR}/emacs/etc
DOCDIR = ${DESTDIR}/doc
INFODIR = ${DESTDIR}/info

## Base name of extensions
ESS = ess-${ESSVERSION}
AUCTEX = auctex-${AUCTEXVERSION}
ORG = org-${ORGVERSION}
POLYMODE = polymode-master
HUNSPELL = hunspell-${HUNSPELLVERSION}-w32-bin
DICT-EN = dict-en_$(subst .,,${DICT-ENVERSION})
DICT-FR = lo-oo-ressources-linguistiques-fr-v${DICT-FRVERSION}
DICT-ES = es_ANY
DICT-DE = dict-de_DE-frami_$(subst .,-,${DICT-DEVERSION})

## Toolset
CP = cp -p
RM = rm -r
UNZIP = 7z x
UNZIPNOPATH = 7z e

all: get-packages emacs

get-packages: get-emacs get-ess get-auctex get-org get-polymode get-markdownmode get-psvn get-hunspell

emacs: dir ess auctex org polymode markdownmode psvn hunspell exe

release: create-release upload publish

.PHONY: emacs dir ess auctex org polymode psvn exe release create-release upload publish clean

dir:
	@echo ----- Creating the application in temporary directory...
	if [ -d ${TMPDIR} ]; then rm -rf ${TMPDIR}; fi
	mkdir -p ${PREFIX}
	${UNZIP} ${ZIPFILE} -o${PREFIX}
	${CP} default.el ${SITELISP}/
	sed '/^(defconst/s/\(emacs-modified-version '"'"'\)[0-9]\+/\1${DISTVERSION}/' \
	    -i -b version-modified.el && \
	  ${CP} version-modified.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/version-modified.el
	${CP} framepop.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/framepop.el
	sed -e '/^AppVerName/s/\(Emacs \)[0-9.]\+-modified-[0-9]\+/\1${VERSION}/' \
	    -e '/^AppId/s/\(GNUEmacs-\)[0-9.]\+-modified-[0-9]\+/\1${VERSION}/' \
	    -e '/^DefaultDirName/s/\(GNU Emacs \)[0-9.]\+/\1${EMACSVERSION}/' \
	    -e '/^DefaultGroupName/s/\(GNU Emacs \)[0-9.]\+/\1${EMACSVERSION}/' \
	    -e '/^OutputBaseFilename/s/\(emacs-\)[0-9.]\+-modified-[0-9]\+/\1${VERSION}/' \
	    -e 's/\(\\emacs\\\)[0-9.]\+/\1${EMACSVERSION}/' \
	    -i -b ${INNOSCRIPT} && \
	  ${CP} ${INNOSCRIPT} ${TMPDIR}/
	sed -e 's/\(ESS \)[0-9.]\+/\1${ESSVERSION}/' \
	    -e 's/\(AUCTeX \)[0-9.]\+/\1${AUCTEXVERSION}/' \
	    -e 's/\(org \)[0-9.]\+/\1${ORGVERSION}/' \
	    -e 's/\(polymode \)[0-9\-]\+/\1${POLYMODEVERSION}/' \
	    -e 's/\(markdown-mode.el \)[0-9.]\+/\1${MARKDOWNMODEVERSION}/' \
	    -e 's/\(psvn.el \)[0-9]\+/\1${PSVNVERSION}/' \
	    -e 's/\(Hunspell \)[0-9.\-]\+/\1${HUNSPELLVERSION}/' \
	    -e 's/\(English (version \)[0-9a-z.]\+/\1${DICT-ENVERSION}/' \
	    -e 's/\(French (version \)[0-9.]\+/\1${DICT-FRVERSION}/' \
	    -e 's/^\(  (version \)[0-9.]\+/\1${DICT-DEVERSION}/' \
	    -e 's/\(Spanish (version \)[0-9.]\+/\1${DICT-ESVERSION}/' \
	    -i -b README-modified.txt && \
	  ${CP} README-modified.txt ${TMPDIR}/
	${CP} site-start.el NEWS ${TMPDIR}

ess:
	@echo ----- Making ESS...
	if [ -d ${ESS} ]; then rm -rf ${ESS}; fi
	${UNZIP} ${ESS}.zip
	TMPDIR=${TMP} ${MAKE} EMACS=${EMACS} -C ${ESS} all
	${MAKE} DESTDIR=${DESTDIR} SITELISP=${SITELISP} \
	        ETCDIR=${ETCDIR}/ess DOCDIR=${DOCDIR}/ess \
	        INFODIR=${INFODIR} -C ${ESS} install
	if [ -f ${SITELISP}/ess-site.el ]; then rm ${SITELISP}/ess-site.el; fi
	rm -rf ${ESS}
	@echo ----- Done making ESS

auctex:
	@echo ----- Making AUCTeX...
	if [ -d ${AUCTEX} ]; then rm -rf ${AUCTEX}; fi
	${UNZIP} ${AUCTEX}.zip
	cd ${AUCTEX} && ./configure --prefix=${PREFIX} \
		--without-texmf-dir \
		--with-emacs=${EMACS}
	make -C ${AUCTEX}
	make -C ${AUCTEX} install
	mv ${SITELISP}/auctex/doc/preview.* ${DOCDIR}/auctex
	rmdir ${SITELISP}/auctex/doc
	rm -rf ${AUCTEX}
	@echo ----- Done making AUCTeX

org:
	@echo ----- Making org...
	if [ -d ${ORG} ]; then rm -rf ${ORG}; fi
	${UNZIP} ${ORG}.zip
	${MAKE} EMACS=${EMACS} -C ${ORG} all
	${MAKE} EMACS=${EMACS} lispdir=${SITELISP}/org \
	        datadir=${ETCDIR}/org infodir=${INFODIR} -C ${ORG} install
	mkdir -p ${DOCDIR}/org && ${CP} ${ORG}/doc/*.html ${DOCDIR}/org/
	rm -rf ${ORG}
	@echo ----- Done making org

polymode:
	@echo ----- Copying and byte compiling polymode files...
	if [ -d ${POLYMODE} ]; then rm -rf ${POLYMODE}; fi
	${UNZIP} ${POLYMODE}.zip
	mkdir -p ${SITELISP}/polymode ${DOCDIR}/polymode
	${CP} ${POLYMODE}/*.el ${POLYMODE}/modes/*.el ${SITELISP}/polymode
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/polymode/*.el
	${CP} ${POLYMODE}/readme.md ${DOCDIR}/polymode
	${CP} ${POLYMODE}/modes/readme.md ${DOCDIR}/polymode/developing.md
	rm -rf ${POLYMODE}
	@echo ----- Done installing polymode

markdownmode:
	@echo ----- Copying and byte compiling markdown-mode.el...
	${CP} markdown-mode.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/markdown-mode.el
	@echo ----- Done installing markdown-mode.el

psvn:
	@echo ----- Patching and byte compiling psvn.el...
	patch -o ${SITELISP}/psvn.el psvn.el psvn.el_svn1.7.diff
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/psvn.el
	@echo ----- Done installing psvn.el

hunspell:
	@echo ----- Installing hunspell and dictionaries...
	if [ -d ${PREFIX}/hunspell ]; then rm -rf ${PREFIX}/hunspell; fi
	mkdir ${PREFIX}/hunspell
	${UNZIP} -o${PREFIX}/hunspell ${HUNSPELL}.zip
	${RM} ${PREFIX}/hunspell/share/hunspell/*
	${UNZIPNOPATH} -o${PREFIX}/hunspell/share/hunspell ${DICT-EN}.zip "*.aff" "*.dic" "th_en*" "README*en*.txt"
	cp ${PREFIX}/hunspell/share/hunspell/en_US.dic ${PREFIX}/hunspell/share/hunspell/default.dic
	cp ${PREFIX}/hunspell/share/hunspell/en_US.aff ${PREFIX}/hunspell/share/hunspell/default.aff
	${UNZIPNOPATH} -o${PREFIX}/hunspell/share/hunspell ${DICT-FR}.zip dictionaries/* 
	${UNZIPNOPATH} -o${PREFIX}/hunspell/share/hunspell ${DICT-ES}.zip "*.aff" "*.dic" "th_es*" "README*es*.txt"
	${UNZIPNOPATH} -o${PREFIX}/hunspell/share/hunspell ${DICT-DE}.zip "de_DE_frami/*.aff" "de_DE_frami/*.dic" "de_DE_frami/*README.txt" "hyph_de_DE/*.dic" "hyph_de_DE/*README.txt" "thes_de_DE_v2/th_de_DE*"


exe:
	@echo ----- Building the archive...
	cd ${TMPDIR}/ && cmd /c "${INNOSETUP} ${INNOSCRIPT}"
	rm -rf ${TMPDIR}
	@echo ----- Done building the archive

create-release:
	@echo ----- Creating release on GitHub...
	@if [ -n "$(shell git status --porcelain | grep -v '^??')" ]; then \
	     echo "uncommitted changes in repository; not creating release"; exit 2; fi
	@if [ -n "$(shell git log origin/master..HEAD)" ]; then \
	    echo "unpushed commits in repository; pushing to origin"; \
	     git push; fi
	if [ -e relnotes.in ]; then rm relnotes.in; fi
	touch relnotes.in
	awk 'BEGIN { ORS=" "; print "{\"tag_name\": \"v${VERSION}\"," } \
	      /^$$/ { next } \
              (state==0) && /^# / { state=1; \
	                            print "\"name\": \"Emacs Modified for Windows ${VERSION}\", \"body\": \""; \
	                             next } \
	      (state==1) && /^# / { state=2; print "\","; next } \
	      state==1 { printf "%s\\n", $$0 } \
	      END { print "\"draft\": false, \"prerelease\": false}" }' \
	      NEWS >> relnotes.in
	curl --data @relnotes.in ${REPOSURL}/releases?access_token=${OAUTHTOKEN}
	rm relnotes.in
	@echo ----- Done creating the release

upload:
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

publish:
	@echo ----- Publishing the web page...
	${MAKE} -C docs
	@echo ----- Done publishing

get-emacs:
	@echo ----- Fetching Emacs...
	if [ -f ${ZIPFILE} ]; then rm ${ZIPFILE}; fi
	curl -OL https://ftp.gnu.org/gnu/emacs/windows/emacs-26/${ZIPFILE}

get-ess:
	@echo ----- Fetching ESS...
	if [ -d ${ESS}.zip ]; then rm ${ESS}.zip; fi
	curl -O http://ess.r-project.org/downloads/ess/${ESS}.zip

get-auctex:
	@echo ----- Fetching AUCTeX...
	if [ -f ${AUCTEX}.zip ]; then rm ${AUCTEX}.zip; fi
	curl -O http://ftp.gnu.org/pub/gnu/auctex/${AUCTEX}.zip

get-org:
	@echo ----- Fetching org...
	if [ -f ${ORG}.zip ]; then rm ${ORG}.zip; fi
	curl -O https://orgmode.org/${ORG}.zip

get-polymode:
	@echo ----- Fetching polymode
	if [ -f ${POLYMODE}.zip ]; then rm ${POLYMODE}.zip; fi
	curl -L -o ${POLYMODE}.zip https://github.com/vspinu/polymode/archive/master.zip

get-markdownmode:
	@echo ----- Fetching markdown-mode.el
	if [ -f markdown-mode.el ]; then rm markdown-mode.el; fi
	curl -OL https://github.com/jrblevin/markdown-mode/raw/v${MARKDOWNMODEVERSION}/markdown-mode.el

get-psvn:
	@echo ----- Fetching psvn.el
	if [ -f psvn.el ]; then rm psvn.el; fi
	svn cat http://svn.apache.org/repos/asf/subversion/trunk/contrib/client-side/emacs/psvn.el > psvn.el && dos2unix -u psvn.el

get-hunspell :
	@echo ----- Fetching hunspell and dictionaries
	if [ -f ${HUNSPELL}.zip ]; then rm ${HUNSPELL}.zip; fi
	curl -OL https://sourceforge.net/projects/ezwinports/files/${HUNSPELL}.zip
	if [ -f ${DICT-EN}.zip ]; then rm ${DICT-EN}.zip; fi
	curl -L -o ${DICT-EN}.zip https://extensions.libreoffice.org/extensions/english-dictionaries/$(shell echo ${DICT-ENVERSION} | sed 's/\./-/')/@@download/file/${DICT-EN}.oxt
	if [ -f ${DICT-FR}.zip ]; then rm ${DICT-FR}.zip; fi
	curl -L -o ${DICT-FR}.zip https://extensions.libreoffice.org/extensions/dictionnaires-francais/${DICT-FRVERSION}/@@download/file/${DICT-FR}.oxt
	if [ -f ${DICT-ES}.zip ]; then rm ${DICT-ES}.zip; fi
	curl -L -o ${DICT-ES}.zip https://extensions.libreoffice.org/extensions/spanish-dictionaries/${DICT-ESVERSION}/@@download/file/${DICT-ES}.oxt
	if [ -f ${DICT-DE}.zip ]; then rm ${DICT-DE}.zip; fi
	curl -L -o ${DICT-DE}.zip https://extensions.libreoffice.org/extensions/german-de-de-frami-dictionaries/$(subst .,-,${DICT-DEVERSION})/@@download/file/${DICT-DE}.oxt

clean:
	${RM} ${TMPDIR}
	cd ${ESS} && ${MAKE} clean
	cd ${AUCTEX} && ${MAKE} clean
