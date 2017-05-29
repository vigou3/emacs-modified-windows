Copyright (C) 2008-2013 Free Software Foundation, Inc.
Copyright (C) 2009-2017 Vincent Goulet for the modifications

=== Emacs Modified for Windows 25.2-modified-3 ===

This is the official release of GNU Emacs for Windows modified to
include the following add-on packages:

* ESS 16.10;
* AUCTeX 11.90;
* org 9.0.6;
* polymode 2016-12-18 (active by default for RMarkdown mode
  only);
* markdown-mode.el 2.1;
* psvn.el 1573006 from Subversion sources, to work with
  Subversion repositories from within Emacs;
* Aspell 0.50.3, a spell checker well integrated with Emacs;
* English (version 0.50-2-3), French (version 0.50-3-3), German
  (version 0.50-2-3) and Spanish (version 0.50-2-3) dictionnaries
   for Aspell;
* Libraries for image formats from the ezwinports project:
  PNG 1.6.12, JPEG v8d, TIFF 4.0.3, GIF 5.1.0 and SVG 2.40.1-2
  (including zlib 1.2.8-2).
* GnuTLS 3.4.15 libraries from the ezwinports project to
  allow Emacs to access web sites using https on Windows.
* w32-winprint.el, to ease printing on Windows;
* htmlize.el, to print in color with w32-winprint.el;
* framepop.el, to obtain temporary buffers in separate frames;
* site-start.el, to make everything work.


To add Emacs extensions to this distribution, simply drop .el files
into the ...\share\emacs\site-lisp\site-start.d\ folder.

In order to use Markdown you may need to install a parser such as
Pandoc (see https://github.com/jgm/pandoc/releases/latest) and
customize 'markdown-command'.

See http://aspell.net/win32/ to install other dictionnaries for Aspell.

See http://sourceforge.net/projects/ezwinports/ to install other Unix
applications sometimes required by Emacs (e.g. diff, gzip).

preview-latex requires an installation of Ghostscript
(http://www.cs.wisc.edu/~ghost/). Make sure the file gswin32c.exe is
somewhere in the PATH environment variable.

If it did not already exist, an environment variable HOME was created
during installation. This variable is required by Emacs and, thus,
should not be removed. The HOME folder will be the default work folder
of Emacs.

Please direct questions or comments on this modified version of
Emacs Modified for Windows to Vincent Goulet <vincent.goulet@act.ulaval.ca>.


Emacs Modified for Windows is free software: you can redistribute it
and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.
