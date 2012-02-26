;;; default.el --- Default configuration for GNU Emacs
;;; Used mainly to load custom extensions.
;;; (Loaded *after* any user and site configuration files)

;; Copyright (C) 2012 Vincent Goulet

;; Author: Vincent Goulet

;; This file is part of Emacs for Windows Modified
;; http://vgoulet.act.ulaval.ca/emacs

;; GNU Emacs for Windows Modified is free software; you can
;; redistribute it and/or modify it under the terms of the GNU General
;; Public License as published by the Free Software Foundation; either
;; version 3, or (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.


;;;
;;; Easier printing
;;;
(require 'w32-winprint)
(require 'htmlize-view)
(htmlize-view-add-to-files-menu)

;;;
;;; ESS
;;;
;; Load ESS and activate the nifty feature showing function arguments
;; in the minibuffer until the call is closed with ')'.
(require 'ess-site)
(require 'ess-eldoc)

;;;
;;; org
;;;
;; Load recent version of org-mode.
(require 'org-install)


;;;
;;; AUCTeX
;;;
;; We assume that MiKTeX (http://www.miktek.org) is used for
;; TeX/LaTeX. Otherwise, change the (require ...) line as per the
;; AUCTeX documentation.
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(require 'tex-mik)


;;;
;;; SVN
;;;
;; Support for the Subversion version control system
;; (http://http://subversion.tigris.org/) in the VC backend. Use 'M-x
;; svn-status RET' on a directory under version control to update,
;; commit changes, revert files, etc., all within Emacs. Requires an
;; installation of Subversion in the path.
(add-to-list 'vc-handled-backends 'SVN)
(require 'psvn)

;;;
;;; Use Aspell for spell checking
;;;
