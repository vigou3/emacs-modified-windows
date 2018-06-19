---
title: Emacs Modified for Windows
tagline: GNU Emacs. Ready for R and LaTeX
description: Distribution of GNU Emacs for R developers and LaTeX users
---

# Presentation

Emacs Modified for Windows is a 64-bit (x64) distribution
of [GNU Emacs](https://www.gnu.org/software/emacs/) **26.1** (released
May 28, 2018) bundled with a few select packages for R developers
and LaTeX users.

The additions to stock Emacs are the following:

- [ESS](http://ess.r-project.org) 17.11;
- [AUCTeX](http://www.gnu.org/software/auctex/) 12.1;
- [org](http://orgmode.org/) 9.1.13;
- [polymode](https://github.com/vitoshka/polymode) 2017-03-07;
- [markdown-mode.el](http://jblevins.org/projects/markdown-mode/) 2.3;
- [psvn.el](http://svn.apache.org/viewvc/subversion/trunk/contrib/client-side/emacs/) r1573006, an interface for the version control system
  [Subversion](http://subversion.tigris.org) modified to include Andre
  Colomb's and Koji Nakamaru's
  [combined patches](http://mail-archives.apache.org/mod_mbox//subversion-dev/201208.mbox/raw/%3c503B958F.6010906@schickhardt.org%3e/1/4)
  to support Subversion >= 1.7;
- [Aspell](http://aspell.net/) 0.50.3; *[Does not work]({{ site.github.releases_url }}/issues/7)*
- English, French, German and Spanish
  [dictionaries](http://aspell.net/win32) for Aspell;
- [framepop.el](http://bazaar.launchpad.net/~vcs-imports/emacs-goodies-el/trunk/view/head:/elisp/emacs-goodies-el/framepop.el)
  to open temporary buffers in a separate frame;
- [default.el]({{ site.github.repository_url }}/tags/v26.1-modified-1/default.el)
  and
  [site-start.el]({{ site.github.repository_url }}/tags/v26.1-modified-1/site-start.el),
  configuration files to make everything work.

The distribution is based on the official GNU release of Emacs with
the optional dependency libraries that enable support for the
following:

- displaying inline images of many types (PNG, JPEG, GIF, TIFF, SVG);
- SSL/TLS secure network communications (HTTPS, IMAPS, etc.);
- HTML and XML parsing (necessary for the built-in EWW browser);
- built-in decompression of compressed text.

## Latest release

Version 26.1-modified-1
([Release notes]({{ site.github.repository_url }}/releases/tag/v26.1-modified-1/))

## System requirements

This distribution requires a 64-bit version of Microsoft Windows.

If you are still running a 32-bit version of Windows you need to install the
32-bit build. The last such version of the distribution was
[25.2-modified-2]({{ site.github.releases_url }}/tag/v25.2-modified-2/).


# Installation

Start the installation wizard and follow the instructions on screen.


# Images and preview-latex mode

This version of Emacs bundles the libraries needed to display images
in formats XPM, PNG, JPEG, TIFF, GIF and SVG supported on Windows
since Emacs version 22.1. Among other things, this means that the
toolbar displays in color, that the ESS toolbar displays correctly and
that the preview-latex mode of
[AUCTeX](http://www.gnu.org/software/auctex/) works to its full
extent. However, the latter requires to separately install
[Ghostscript](http://www.cs.wisc.edu/~ghost/ "Ghostscript/view
utilities") and to make sure that the file `gswin32c.exe` or
`gswin64c.exe` is in a folder along the `PATH` environment variable.

The previous comment also applies to the image conversion
tool [ImageMagick](https://www.imagemagick.org/) that may be required
by Org. If you need the tool, install it and make sure its location is
along the `PATH`.


# Unix applications

Emacs sometimes uses external applications that are standard on Unix but
not available on Windows (for example: `diff`, `gzip`). When needed,
install the applications from the
[ezwinports](http://sourceforge.net/projects/ezwinports/) project. To
make sure Emacs can find the applications, include the folder where they
are installed to the `PATH` environment variable. *(With thanks to
Laurent Pantera for the hint.)*


# Also available

[Emacs Modified for macOS](https://{{ site.github.owner_name }}.{{ site.github.pages_hostname }}/emacs-modified-macos/).
