;;; site-start.el --- Customizations for Emacs Modified for Windows
;;
;; Copyright (C) 2015-2017 Vincent Goulet
;;
;; Author: Vincent Goulet
;;
;; This file is part of Emacs Modified for Windows
;; https://gitlab.com/vigou3/emacs-modified-windows

;; GNU Emacs.app Modified is free software; you can redistribute it
;; and/or modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.


;;;
;;; Nice options to have On by default
;;;
(mouse-wheel-mode t)			; activate mouse scrolling
(global-font-lock-mode t)		; syntax highlighting
(transient-mark-mode t)			; sane select (mark) mode
(delete-selection-mode t)		; entry deletes marked text
(show-paren-mode t)			; match parentheses
(add-hook 'text-mode-hook 'turn-on-auto-fill) ; wrap long lines in text mode

;;;
;;; ESS
;;;
;; Following the "source is real" philosophy put forward by ESS, one
;; should not need the command history and should not save the
;; workspace at the end of an R session. Hence, both options are
;; disabled here.
(setq-default inferior-R-args "--no-save ")

;; Enable sweaving directly within the AUCTeX ecosystem.
(setq-default ess-swv-plug-into-AUCTeX-p t)

;; Automagically delete trailing whitespace when saving R script
;; files. One can add other commands in the ess-mode-hook below.
(add-hook 'ess-mode-hook
	  '(lambda()
	     (add-hook 'write-contents-functions
		       (lambda ()
                         (ess-nuke-trailing-whitespace)))
	     (setq ess-nuke-trailing-whitespace-p t)))

;; Load ESS.
(require 'ess-site)

;;;
;;; AUCTeX
;;;
;; Turn on RefTeX for LaTeX documents. Put further RefTeX
;; customizations in your .emacs file.
(add-hook 'LaTeX-mode-hook
	  (lambda ()
	    (turn-on-reftex)
	    (setq reftex-plug-into-AUCTeX t)))

;; Load AUCTeX and preview-latex.
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)

;;;
;;; markdown-mode
;;;
;; Activation of markdown-mode for common file extensions. One will
;; also need to install a Markdown parser (such as 'pandoc') and then
;; to indicate its location by customizing the variable
;; 'markdown-command'.
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)

;;;
;;; SVN
;;;
;; Support for the Subversion version control system
;; (http://http://subversion.tigris.org/) in the VC backend. Use 'M-x
;; svn-status RET' on a directory under version control to update,
;; commit changes, revert files, etc., all within Emacs. Requires an
;; installation of Subversion in the path.
(add-to-list 'vc-handled-backends 'SVN)
(add-hook 'svn-log-edit-mode-hook 'turn-off-auto-fill) ; useful option
(require 'psvn)

;;;
;;; Use Hunspell for spell checking
;;;
(setq-default ispell-program-name "<EMACSDIR>/hunspell/bin/hunspell.exe")

;;;
;;; Other extensions
;;;
;; Emacs will load all ".el" files in
;;   <EMACSDIR>/share/emacs/site-lisp/site-start.d/
;; on startup.
(mapc 'load
      (directory-files "<EMACSDIR>/share/emacs/site-lisp/site-start.d" t "\\.el\\'"))
