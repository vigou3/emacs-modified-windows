---
title: Emacs Modified for Windows
description: GNU Emacs. Ready for R and LaTeX
---

# Presentation

Emacs Modified for Windows is a 64-bit (x64) distribution
of [GNU Emacs](https://www.gnu.org/software/emacs/) **26.3** (released
August 28, 2019) bundled with a few select packages for R developers
and LaTeX users.

The additions to stock Emacs are the following:

- [ESS](http://ess.r-project.org) 18.10.2;
- [AUCTeX](http://www.gnu.org/software/auctex/) 12.1;
- [org](http://orgmode.org/) 9.2.4;
- [Tabbar](https://github.com/dholm/tabbar) 2.2, a minor mode that displays a tab bar at the top of the Emacs window, similar to the idea of web browsers tabs;
- [markdown-mode.el](http://jblevins.org/projects/markdown-mode/) 2.3;
- [psvn.el](http://svn.apache.org/viewvc/subversion/trunk/contrib/client-side/emacs/) r1573006, an interface for the version control system
  [Subversion](http://subversion.tigris.org) modified to include Andre
  Colomb's and Koji Nakamaru's
  [combined patches](http://mail-archives.apache.org/mod_mbox//subversion-dev/201208.mbox/raw/%3c503B958F.6010906@schickhardt.org%3e/1/4)
  to support Subversion >= 1.7;
- [Hunspell](https://hunspell.github.io/) 1.3.2-3;
- [English](https://extensions.libreoffice.org/extensions/english-dictionaries) (version 2019.07.01),
  [French](https://extensions.libreoffice.org/extensions/dictionnaires-francais) (version 5.7), 
  [German](https://extensions.libreoffice.org/extensions/german-de-de-frami-dictionaries) (version 2017.01.12) and 
  [Spanish](https://extensions.libreoffice.org/extensions/spanish-dictionaries) (version 2.4) dictionnaries for Hunspell;
- [framepop.el](http://bazaar.launchpad.net/~vcs-imports/emacs-goodies-el/trunk/view/head:/elisp/emacs-goodies-el/framepop.el)
  to open temporary buffers in a separate frame;
- [default.el](https://gitlab.com/vigou3/emacs-modified-windows/blob/v26.2-modified-2/default.el)
  and
  [site-start.el](https://gitlab.com/vigou3/emacs-modified-windows/blob/v26.2-modified-2/site-start.el),
  configuration files to make everything work.

The distribution is based on the official GNU release of Emacs with
the optional dependency libraries that enable support for the
following:

- displaying inline images of many types (PNG, JPEG, GIF, TIFF, SVG);
- SSL/TLS secure network communications (HTTPS, IMAPS, etc.);
- HTML and XML parsing (necessary for the built-in EWW browser);
- built-in decompression of compressed text.

## Latest release

Version 26.2-modified-2
([Release notes](https://gitlab.com/vigou3/emacs-modified-windows/tags/v26.2-modified-2/))

## System requirements

This distribution requires a 64-bit version of Microsoft Windows.

If you are still running a 32-bit version of Windows you need to install the
32-bit build. The last such version of the distribution was
[25.2-modified-2](https://gitlab.com/vigou3/emacs-modified-windows/tags/v25.2-modified-2/).


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


# Additional packages

If you want to install additional Emacs packages
([polymode](https://polymode.github.io) comes to mind, here) through
the [MELPA](https://melpa.org/) repository, add the following lines
to your `.emacs` configuration file:

```
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(package-initialize)
```


# Unix applications

Emacs sometimes uses external applications that are standard on Unix but
not available on Windows (for example: `diff`, `gzip`). When needed,
install the applications from the
[ezwinports](http://sourceforge.net/projects/ezwinports/) project. To
make sure Emacs can find the applications, include the folder where they
are installed to the `PATH` environment variable. *(With thanks to
Laurent Pantera for the hint.)*


# Also available

[Emacs Modified for macOS](https://vigou3.gitlab.io/emacs-modified-macos/).
