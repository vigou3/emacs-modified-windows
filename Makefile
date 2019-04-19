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
## https://gitlab.com/vigou3/emacs-modified-windows

## Emacs Modified for Windows is free software; you can redistribute
## it and/or modify it under the terms of the GNU General Public
## License as published by the Free Software Foundation; either
## version 3, or (at your option) any later version.
##
## GNU Emacs is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with GNU Emacs; see the file COPYING.  If not, write to the
## Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
## Boston, MA 02110-1301, USA.

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

## Toolset
CP = cp -p
RM = rm -r
UNZIP = 7z x
UNZIPNOPATH = 7z e

all: get-packages emacs

get-packages: get-emacs get-ess get-auctex get-org get-markdownmode get-psvn get-hunspell

emacs: dir ess auctex org markdownmode psvn hunspell exe

release: check-status upload create-release publish

.PHONY: dir
dir:
	@echo ----- Creating the application in temporary directory...
	if [ -d ${TMPDIR} ]; then ${RM} -f ${TMPDIR}; fi
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
	    -e 's/\(markdown-mode.el \)[0-9.]\+/\1${MARKDOWNMODEVERSION}/' \
	    -e 's/\(psvn.el r\)[0-9]\+/\1${PSVNVERSION}/' \
	    -e 's/\(Hunspell \)[0-9.\-]\+/\1${HUNSPELLVERSION}/' \
	    -e 's/\(English (version \)[0-9a-z.]\+/\1${DICT-ENVERSION}/' \
	    -e 's/\(French (version \)[0-9.]\+/\1${DICT-FRVERSION}/' \
	    -e 's/^\(  (version \)[0-9.]\+/\1${DICT-DEVERSION}/' \
	    -e 's/\(Spanish (version \)[0-9.]\+/\1${DICT-ESVERSION}/' \
	    -i -b README-modified.txt && \
	  ${CP} README-modified.txt ${TMPDIR}/
	${CP} site-start.el NEWS ${TMPDIR}

.PHONY: ess
ess:
	@echo ----- Making ESS...
	if [ -d ${ESS} ]; then ${RM} -f ${ESS}; fi
	${UNZIP} ${ESS}.zip
	patch  ${ESS}/lisp/ess-sp6-d.el ess-sp6-d.diff && ${RM} ${ESS}/lisp/ess-sp6-d.el.orig # temporary; should be fixed for ESS > 18.10.2
	TMPDIR=${TMP} ${MAKE} EMACS=${EMACS} -C ${ESS} all
	${MAKE} DESTDIR=${DESTDIR} SITELISP=${SITELISP} \
	        ETCDIR=${ETCDIR}/ess DOCDIR=${DOCDIR}/ess \
	        INFODIR=${INFODIR} -C ${ESS} install
	${CP} ${ESS}/lisp/*.el ${SITELISP}/ess # temporary; should be fixed for ESS > 18.10.2
	if [ -f ${SITELISP}/ess-site.el ]; then rm ${SITELISP}/ess-site.el; fi
	${RM} -f ${ESS}
	@echo ----- Done making ESS

.PHONY: auctex
auctex:
	@echo ----- Making AUCTeX...
	if [ -d ${AUCTEX} ]; then ${RM} -f ${AUCTEX}; fi
	${UNZIP} ${AUCTEX}.zip
	cd ${AUCTEX} && ./configure --prefix=${PREFIX} \
		--without-texmf-dir \
		--with-emacs=${EMACS}
	make -C ${AUCTEX}
	make -C ${AUCTEX} install
	mv ${SITELISP}/auctex/doc/preview.* ${DOCDIR}/auctex
	rmdir ${SITELISP}/auctex/doc
	${RM} -f ${AUCTEX}
	@echo ----- Done making AUCTeX

.PHONY: org
org:
	@echo ----- Making org...
	if [ -d ${ORG} ]; then ${RM} -f ${ORG}; fi
	${UNZIP} ${ORG}.zip
	${MAKE} EMACS=${EMACS} -C ${ORG} all
	${MAKE} EMACS=${EMACS} lispdir=${SITELISP}/org \
	        datadir=${ETCDIR}/org infodir=${INFODIR} -C ${ORG} install
	mkdir -p ${DOCDIR}/org && ${CP} ${ORG}/doc/*.html ${DOCDIR}/org/
	${RM} -f ${ORG}
	@echo ----- Done making org

.PHONY: markdownmode
markdownmode:
	@echo ----- Copying and byte compiling markdown-mode.el...
	${CP} markdown-mode.el ${SITELISP}/
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/markdown-mode.el
	@echo ----- Done installing markdown-mode.el

.PHONY: psvn
psvn:
	@echo ----- Patching and byte compiling psvn.el...
	patch -o ${SITELISP}/psvn.el psvn.el psvn.el_svn1.7.diff
	$(EMACSBATCH) -f batch-byte-compile ${SITELISP}/psvn.el
	@echo ----- Done installing psvn.el

.PHONY: hunspell
hunspell:
	@echo ----- Installing hunspell and dictionaries...
	if [ -d ${PREFIX}/hunspell ]; then ${RM} -f ${PREFIX}/hunspell; fi
	mkdir ${PREFIX}/hunspell
	${UNZIP} -o${PREFIX}/hunspell ${HUNSPELL}.zip
	${RM} ${PREFIX}/hunspell/share/hunspell/*
	${UNZIPNOPATH} -o${PREFIX}/hunspell/share/hunspell ${DICT-EN}.zip "*.aff" "*.dic" "th_en*" "README*en*.txt"
	cp ${PREFIX}/hunspell/share/hunspell/en_US.dic ${PREFIX}/hunspell/share/hunspell/default.dic
	cp ${PREFIX}/hunspell/share/hunspell/en_US.aff ${PREFIX}/hunspell/share/hunspell/default.aff
	${UNZIPNOPATH} -o${PREFIX}/hunspell/share/hunspell ${DICT-FR}.zip dictionaries/* 
	${UNZIPNOPATH} -o${PREFIX}/hunspell/share/hunspell ${DICT-ES}.zip "*.aff" "*.dic" "th_es*" "README*es*.txt"
	${UNZIPNOPATH} -o${PREFIX}/hunspell/share/hunspell ${DICT-DE}.zip "de_DE_frami/*.aff" "de_DE_frami/*.dic" "de_DE_frami/*README.txt" "hyph_de_DE/*.dic" "hyph_de_DE/*README.txt" "thes_de_DE_v2/th_de_DE*"

.PHONY: exe
exe:
	@echo ----- Building the archive...
	cd ${TMPDIR}/ && cmd /c "${INNOSETUP} ${INNOSCRIPT}"
	${RM} -f ${TMPDIR}
	@echo ----- Done building the archive

.PHONY: check-status
check-status:
	@echo ----- Checking status of working directory...
	@if [ "master" != $(shell git branch --list | grep ^* | cut -d " " -f 2-) ]; then \
	     echo "not on branch master"; exit 2; fi
	@if [ -n "$(shell git status --porcelain | grep -v '^??')" ]; then \
	     echo "uncommitted changes in repository; not creating release"; exit 2; fi
	@if [ -n "$(shell git log origin/master..HEAD)" ]; then \
	    echo "unpushed commits in repository; pushing to origin"; \
	     git push; fi

.PHONY: upload
upload:
	@echo ----- Uploading installer to GitLab...
	$(eval upload_url_markdown=$(shell curl --form "file=@emacs-${VERSION}.exe" \
	                                        --header "PRIVATE-TOKEN: ${OAUTHTOKEN}"	\
	                                        --silent \
	                                        ${APIURL}/uploads \
	                                   | awk -F '"' '{ print $$12 }'))
	@echo Markdown ready url to file:
	@echo "${upload_url_markdown}"
	@echo ----- Done uploading installer

.PHONY: create-release
create-release:
	@echo ----- Creating release on GitLab...
	if [ -e relnotes.in ]; then ${RM} relnotes.in; fi
	touch relnotes.in
	$(eval FILESIZE=$(shell du -h emacs-${VERSION}.exe | cut -f1 | sed 's/\([KMG]\)/ \1b/'))
	awk 'BEGIN { ORS = " "; print "{\"tag_name\": \"${TAGNAME}\"," } \
	      /^$$/ { next } \
	      (state == 0) && /^# / { state = 1; \
		out = $$3; \
	        for(i = 4; i <= NF; i++) { out = out" "$$i }; \
	        printf "\"description\": \"# Emacs Modified for Windows %s\\n", out; \
	        next } \
	      (state == 1) && /^# / { exit } \
	      state == 1 { printf "%s\\n", $$0 } \
	      END { print "\\n## Download the installer\\n${upload_url_markdown} (${FILESIZE})\"}" }' \
	     NEWS >> relnotes.in
	curl --request POST \
	     --header "PRIVATE-TOKEN: ${OAUTHTOKEN}" \
	     "${APIURL}/repository/tags?tag_name=${TAGNAME}&ref=master"
	curl --data @relnotes.in \
	     --header "PRIVATE-TOKEN: ${OAUTHTOKEN}" \
	     --header "Content-Type: application/json" \
	     ${APIURL}/repository/tags/${TAGNAME}/release
	${RM} relnotes.in
	@echo ----- Done creating the release

.PHONY: publish
publish:
	@echo ----- Publishing the web page...
	git checkout pages && \
	  ${MAKE} && \
	  git checkout master
	@echo ----- Done publishing

.PHONY: get-emacs
get-emacs:
	@echo ----- Fetching Emacs...
	if [ -f ${ZIPFILE} ]; then ${RM} ${ZIPFILE}; fi
	curl -OL https://ftp.gnu.org/gnu/emacs/windows/emacs-26/${ZIPFILE}

.PHONY: get-ess
get-ess:
	@echo ----- Fetching ESS...
	if [ -d ${ESS}.zip ]; then ${RM} ${ESS}.zip; fi
	curl -O http://ess.r-project.org/downloads/ess/${ESS}.zip

.PHONY: get-auctex
get-auctex:
	@echo ----- Fetching AUCTeX...
	if [ -f ${AUCTEX}.zip ]; then ${RM} ${AUCTEX}.zip; fi
	curl -O http://ftp.gnu.org/pub/gnu/auctex/${AUCTEX}.zip

.PHONY: get-org
get-org:
	@echo ----- Fetching org...
	if [ -f ${ORG}.zip ]; then ${RM} ${ORG}.zip; fi
	curl -O https://orgmode.org/${ORG}.zip

.PHONY: get-markdownmode
get-markdownmode:
	@echo ----- Fetching markdown-mode.el
	if [ -f markdown-mode.el ]; then ${RM} markdown-mode.el; fi
	curl -OL https://github.com/jrblevin/markdown-mode/raw/v${MARKDOWNMODEVERSION}/markdown-mode.el

.PHONY: get-psvn
get-psvn:
	@echo ----- Fetching psvn.el
	if [ -f psvn.el ]; then ${RM} psvn.el; fi
	svn cat http://svn.apache.org/repos/asf/subversion/trunk/contrib/client-side/emacs/psvn.el > psvn.el && dos2unix -u psvn.el

.PHONY: get-hunspell
get-hunspell:
	@echo ----- Fetching hunspell and dictionaries
	if [ -f ${HUNSPELL}.zip ]; then ${RM} ${HUNSPELL}.zip; fi
	curl -OL https://sourceforge.net/projects/ezwinports/files/${HUNSPELL}.zip
	if [ -f ${DICT-EN}.zip ]; then ${RM} ${DICT-EN}.zip; fi
	curl -L -o ${DICT-EN}.zip https://extensions.libreoffice.org/extensions/english-dictionaries/$(shell echo ${DICT-ENVERSION} | sed 's/\./-/')/@@download/file/${DICT-EN}.oxt
	if [ -f ${DICT-FR}.zip ]; then ${RM} ${DICT-FR}.zip; fi
	curl -L -o ${DICT-FR}.zip https://extensions.libreoffice.org/extensions/dictionnaires-francais/${DICT-FRVERSION}/@@download/file/${DICT-FR}.oxt
	if [ -f ${DICT-ES}.zip ]; then ${RM} ${DICT-ES}.zip; fi
	curl -L -o ${DICT-ES}.zip https://extensions.libreoffice.org/extensions/spanish-dictionaries/${DICT-ESVERSION}/@@download/file/${DICT-ES}.oxt
	if [ -f ${DICT-DE}.zip ]; then ${RM} ${DICT-DE}.zip; fi
	curl -L -o ${DICT-DE}.zip https://extensions.libreoffice.org/extensions/german-de-de-frami-dictionaries/$(subst .,-,${DICT-DEVERSION})/@@download/file/${DICT-DE}.oxt

.PHONY: clean
clean:
	${RM} ${TMPDIR}
	cd ${ESS} && ${MAKE} clean
	cd ${AUCTEX} && ${MAKE} clean
