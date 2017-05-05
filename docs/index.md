Presentation
============

Emacs Modified for Windows is a distribution of GNU Emacs **25.1**
(released September 17, 2016) bundled with a few select packages for
LaTeX users and R developers.

The additions to stock Emacs are the following:

-   [ESS](http://ess.r-project.org) 16.10;
-   [AUCTeX](http://www.gnu.org/software/auctex/) 11.90;
-   [org](http://orgmode.org/) 9.0.6;
-   [polymode](https://github.com/vitoshka/polymode) 2016-12-18;
-   [`markdown-mode.el`](http://jblevins.org/projects/markdown-mode/) 2.1;
-   [`psvn.el`](http://svn.apache.org/viewvc/subversion/trunk/contrib/client-side/emacs/)
    r1573006, an interface for the version control system
    [Subversion](http://subversion.tigris.org) modified to include
    Andre Colomb's and Koji Nakamaru's
    [combined patches](http://mail-archives.apache.org/mod_mbox//subversion-dev/201208.mbox/raw/%3c503B958F.6010906@schickhardt.org%3e/1/4)
    to support Subversion 1.7;
-   [Aspell](http://aspell.net/) 0.50.3;
-   English, French, German and Spanish
    [dictionaries](http://aspell.net/win32) for Aspell;
-   libraries for image formats from the
    [ezwinports](http://sourceforge.net/projects/ezwinports/files/) 
    project: PNG 1.6.12, JPEG v8d, TIFF 4.0.3, 
	GIF 5.1.0 and SVG 2.40.1-2 (including zlib 1.2.8-2);
-   [GnuTLS](http://www.gnutls.org) libraries 3.4.15 from the
    [ezwinports](http://sourceforge.net/projects/ezwinports/files/)
    project to allow Emacs to access web sites using `https` on Windows;
-   [`framepop.el`](http://bazaar.launchpad.net/~vcs-imports/emacs-goodies-el/trunk/view/head:/elisp/emacs-goodies-el/framepop.el)
    to open temporary buffers in a separate frame;
-   [`w32-winprint.el`](http://www.emacswiki.org/cgi-bin/emacs?action=browse;id=w32-winprint.el),
    to ease printing under Windows;
-   [`htmlize.el`](http://fly.srk.fer.hr/~hniksic/emacs/htmlize.el), to
    print in color with `w32-winprint.el`;
-   [`default.el`]({{ site.github.repository_url }}/tags/v25.2-modified-2/default.el)
    and
    [`site-start.el`]({{ site.github.repository_url }}/tags/v25.2-modified-2/site-start.el),
    configuration files to make everything work.

This distribution is based on the latest stable official release of GNU Emacs.

Latest release
--------------

Version 25.2-modified-2 ([Release notes]({{ site.github.repository_url }}/releases/tag/v25.2-modified-2/))

Installation
============

Start the installation wizard and follow the instructions on screen.

Images and preview-latex mode
=============================

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

Emacs font
==========

Tired of the Courier font Emacs uses by default under Windows? One nice
alternative is the Consolas family of fonts.

Set the Emacs font by adding the following lines to your `.emacs`
initialization file:

```lisp
(set-face-font 'default "-outline-Consolas-normal-r-normal-normal-*-*-96-96-c-*-iso8859-1")
(set-face-font 'bold "-outline-Consolas-bold-r-normal-normal-*-*-96-96-c-*-iso8859-1")
(set-face-font 'italic "-outline-Consolas-normal-i-normal-normal-*-*-96-96-c-*-iso8859-1")
(set-face-font 'bold-italic "-outline-Consolas-bold-i-normal-normal-*-*-96-96-c-*-iso8859-1")
```

(Replace `iso8859-1` by the desired encoding if needed.)

You may also use the `Set Default Font...` entry in the Options menu.

Unix applications
=================

Emacs sometimes uses external applications that are standard on Unix but
not available on Windows (for example: `diff`, `gzip`). When needed,
install the applications from the
[ezwinports](http://sourceforge.net/projects/ezwinports/) project. To
make sure Emacs can find the applications, include the folder where they
are installed to the `PATH` environment variable. *(With thanks to
Laurent Pantera for the hint.)*

Also available
==============

[Emacs Modified for macOS](https://{{ site.github.owner_name }}.{{ site.github.pages_hostname }}/emacs-modified-macos/).
