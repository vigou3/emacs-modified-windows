### Makefile for GitHub page of Emacs Modified for Windows
##
## Copyright (C) 2017 Vincent Goulet
##
## Author: Vincent Goulet
##
## This file is part of Emacs Modified for Windows
## http://github.com/vigou3/emacs-modified-windows

## Get version strings in Makeconf
include ../Makeconf

## GitHub repository and authentication
REPOSURL=https://api.github.com/repos/vigou3/emacs-modified-windows
OAUTHTOKEN=$(shell cat ~/.github/token)

INDEX = index.md
DEFAULT = _layouts/default.html

all: files commit

files: 
	sed -e '/^\[25.2-modified-2\]/! s/[0-9.]\+-modified-[0-9]\+/${VERSION}/g' \
	    -e '/\[ESS\]/s/[0-9]\+[0-9.]*/${ESSVERSION}/' \
	    -e '/\[AUCTeX\]/s/[0-9]\+[0-9.]*/${AUCTEXVERSION}/' \
	    -e '/\[org\]/s/[0-9]\+[0-9.]*/${ORGVERSION}/' \
	    -e '/\[polymode\]/s/[0-9]\+[0-9\-]*/${POLYMODEVERSION}/' \
	    -e '/\[markdown-mode.el\]/s/[0-9]\+[0-9.]*/${MARKDOWNMODEVERSION}/' \
	    -e '/\[psvn.el\]/s/r[0-9]\+/r${PSVNVERSION}/' \
	    -i ${INDEX}
	sed '/{{ site.github.releases_url }}/s/[0-9.]\+-modified-[0-9]\+/${VERSION}/g' \
	    -i ${DEFAULT}

commit:
	git commit -a -m "Updating the web page for version ${VERSION}" && \
	git push
