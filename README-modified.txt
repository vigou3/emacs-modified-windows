Copyright (C) 2001-2017 Free Software Foundation, Inc.
Copyright (C) 2009-2018 Vincent Goulet for the modifications.
See below for GNU Emacs license conditions.

Emacs Modified for Windows
==========================

This is GNU Emacs for Windows 64-bit (x64) modified to include the
following add-on packages:

- ESS 17.11;
- AUCTeX 12.1;
- org 9.1.13;
- polymode 2017-03-07 (active by default for RMarkdown mode
  only);
- markdown-mode.el 2.3;
- psvn.el 1573006 from Subversion sources, to work with
  Subversion repositories from within Emacs;
- Aspell 0.50.3, a spell checker well integrated with Emacs;
- English (version 0.50-2-3), French (version 0.50-3-3), German
  (version 0.50-2-3) and Spanish (version 0.50-2-3) dictionnaries
   for Aspell;
- framepop.el, to obtain temporary buffers in separate frames;
- default.el and site-start.el files to make everything work together.

The distribution is based on the official GNU release of Emacs with
the optional dependency libraries that enable support for the
following:

- displaying inline images of many types (PNG, JPEG, GIF, TIFF, SVG);
- SSL/TLS secure network communications (HTTPS, IMAPS, etc.);
- HTML and XML parsing (necessary for the built-in EWW browser);
- built-in decompression of compressed text.

To add Emacs extensions to this distribution, you may drop .el files
into the ...\share\emacs\site-lisp\site-start.d\ folder.

In order to use Markdown you may need to install a parser such as
Pandoc (see https://github.com/jgm/pandoc/releases/latest) and
customize 'markdown-command'.

See http://aspell.net/win32/ to install other dictionnaries for Aspell.

See http://sourceforge.net/projects/ezwinports/ to install Unix
utilities sometimes required by Emacs (e.g. diff, gzip).

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

GNU Emacs
=========

GNU Emacs is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

GNU Emacs is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.
