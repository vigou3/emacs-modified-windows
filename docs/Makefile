### Makefile for GitHub page of GNU Emacs Modified for Windows
##
## Copyright (C) 2017 Vincent Goulet
##
## Author: Vincent Goulet
##
## This file is part of GNU Emacs for macOS Modified
## http://github.com/vigou3/emacs-modified-macos

## Get version strings in Makeconf
include ../Makeconf

all : 
	sed -e 's/<ESSVERSION>/${ESSVERSION}/'       \
	    -e 's/<AUCTEXVERSION>/${AUCTEXVERSION}/' \
	    -e 's/<ORGVERSION>/${ORGVERSION}/'     \
	    -e 's/<POLYMODEVERSION>/${POLYMODEVERSION}/' \
	    -e 's/<MARKDOWNMODEVERSION>/${MARKDOWNMODEVERSION}/' \
	    -e 's/<PSVNVERSION>/${PSVNVERSION}/'     \
	    -e 's/<LIBPNGVERSION>/${LIBPNGVERSION}/' \
	    -e 's/<LIBZLIBVERSION>/${LIBZLIBVERSION}/' \
	    -e 's/<LIBJPEGVERSION>/${LIBJPEGVERSION}/' \
	    -e 's/<LIBTIFFVERSION>/${LIBTIFFVERSION}/' \
	    -e 's/<LIBGIFVERSION>/${LIBGIFVERSION}/' \
	    -e 's/<LIBSVGVERSION>/${LIBSVGVERSION}/' \
	    -e 's/<LIBGNUTLSVERSION>/${LIBGNUTLSVERSION}/' \
	    -e 's/<VERSION>/${VERSION}/g'             \
	    index.md.in > index.md
	sed -e 's/<VERSION>/${VERSION}/g'     \
	    -e 's/<DISTNAME>/${DISTNAME}/'      \
	    _layouts/default.html.in > _layouts/default.html
	git commit -a -m "Updating the web page for version ${VERSION}" && \
	git push

