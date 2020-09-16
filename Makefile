### -*-Makefile-*- for GitLab page of Emacs Modified for Windows
##
## Copyright (C) 2020 Vincent Goulet
##
## Author: Vincent Goulet
##
## This file is part of Emacs Modified for Windoes
## https://gitlab.com/vigou3/emacs-modified-windows


## Get variables and version strings from Makeconf, NEWS and
## README.txt files in master branch (version strings are computed in
## Makeconf, hence we cannot use them directly here)
## Get variables and version strings from Makeconf in master branch
## (version strings are computed in Makeconf, hence we cannot use them
## directly here)
EMACSVERSION = $(shell git show master:Makeconf \
	| grep ^EMACSVERSION \
	| cut -d = -f 2)
EMACSPATCHLEVEL = $(shell git show master:Makeconf \
	| grep ^EMACSPATCHLEVEL \
	| cut -d = -f 2)
DISTVERSION = $(shell git show master:Makeconf \
	| grep ^DISTVERSION \
	| cut -d = -f 2)
ESSVERSION = $(shell git show master:Makeconf \
	| grep ^ESSVERSION \
	| cut -d = -f 2)
AUCTEXVERSION = $(shell git show master:Makeconf \
	| grep ^AUCTEXVERSION \
	| cut -d = -f 2)
ORGVERSION = $(shell git show master:Makeconf \
	| grep ^ORGVERSION \
	| cut -d = -f 2)
MARKDOWNMODEVERSION = $(shell git show master:Makeconf \
	| grep ^MARKDOWNMODEVERSION \
	| cut -d = -f 2)
EXECPATHVERSION = $(shell git show master:Makeconf \
	| grep ^EXECPATHVERSION \
	| cut -d = -f 2)
PSVNVERSION = $(shell git show master:Makeconf \
	| grep ^PSVNVERSION \
	| cut -d = -f 2)
TABBARVERSION = $(shell git show master:Makeconf \
	| grep ^TABBARVERSION \
	| cut -d = -f 2)
HUNSPELLVERSION = $(shell git show master:Makeconf \
	| grep ^HUNSPELLVERSION \
	| cut -d = -f 2)
DICT-ENVERSION = $(shell git show master:Makeconf \
	| grep ^DICT-ENVERSION \
	| cut -d = -f 2)
DICT-FRVERSION = $(shell git show master:Makeconf \
	| grep ^DICT-FRVERSION \
	| cut -d = -f 2)
DICT-DEVERSION = $(shell git show master:Makeconf \
	| grep ^DICT-DEVERSION \
	| cut -d = -f 2)
DICT-ESVERSION = $(shell git show master:Makeconf \
	| grep ^DICT-ESVERSION \
	| cut -d = -f 2)
REPOSURL = $(shell git show master:Makeconf \
	| grep ^REPOSURL \
	| cut -d = -f 2)

## GitLab repository and authentication
REPOSNAME = $(shell basename ${REPOSURL})
APIURL = https://gitlab.com/api/v4/projects/vigou3%2F${REPOSNAME}
OAUTHTOKEN = $(shell cat ~/.gitlab/token)

## Automatic variable
VERSION=${EMACSVERSION}$(if ${EMACSPATCHLEVEL},-${EMACSPATCHLEVEL},)-modified-${DISTVERSION}
TAGNAME = v${VERSION}


all: files commit

files: 
	$(eval url=$(subst /,\/,$(patsubst %/,%,${REPOSURL})))
	$(eval file_id=$(shell curl --header "PRIVATE-TOKEN: ${OAUTHTOKEN}" \
	                             --silent \
	                             ${APIURL}/releases/${TAGNAME}/assets/links \
				| sed -E 's/.*\"direct_asset_url\":\"([^"]*)\".*/\1/' \
				| cut -d/ -f7))
	cd content && \
	  sed -e '/^\[25.2-modified-2\]/! s/[0-9.-]\+-modified-[0-9]\+/${VERSION}/g' \
	      -e '/\[ESS\]/s/[0-9]\+[0-9.]*/${ESSVERSION}/' \
	      -e '/\[AUCTeX\]/s/[0-9]\+[0-9.]*/${AUCTEXVERSION}/' \
	      -e '/\[org\]/s/[0-9]\+[0-9.]*/${ORGVERSION}/' \
	      -e '/\[Tabbar\]/s/[0-9]\+[0-9.]*/${TABBARVERSION}/' \
	      -e '/\[markdown-mode.el\]/s/[0-9]\+[0-9.]*/${MARKDOWNMODEVERSION}/' \
	      -e '/\[psvn.el\]/s/r[0-9]\+/r${PSVNVERSION}/' \
	      -e '/\[Hunspell\]/s/[0-9]\+[0-9.]*[0-9\-]*/${HUNSPELLVERSION}/' \
	      -e '/\[English\]/s/version [0-9.]\+[a-z]\?/version ${DICT-ENVERSION}/' \
	      -e '/\[French\]/s/version [0-9.]\+/version ${DICT-FRVERSION}/' \
	      -e '/\[German\]/s/version [0-9.]\+/version ${DICT-DEVERSION}/' \
	      -e '/\[Spanish\]/s/version [0-9.]\+/version ${DICT-ESVERSION}/' \
	       _index.md > tmpfile && \
	  mv tmpfile _index.md
	cd layouts/partials && \
	  awk 'BEGIN { FS = "/"; OFS = "/" } \
	       /${url}\/uploads/ { if (NF > 8) { \
		                       print "too many fields in the uploads url" > "/dev/stderr"; \
				       exit 1; } \
				   $$7 = "${file_id}"; \
	                           sub(/.*\.exe/, "emacs-${VERSION}.exe", $$8) } \
	       1' \
	       site-header.html > tmpfile && \
	  mv tmpfile site-header.html

commit:
	git commit content/_index.md layouts/partials/site-header.html \
	    -m "Updated web page for version ${VERSION}"
	git push
