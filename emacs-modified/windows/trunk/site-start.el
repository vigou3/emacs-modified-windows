;;; site-start.el --- Site configuration for GNU Emacs

;; Copyright (C) 2009 Vincent Goulet

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
;;; Nice options to have On by default
;;;
(global-font-lock-mode t)		; syntax highlighting
(transient-mark-mode t)			; sane select (mark) mode
(delete-selection-mode t)		; entry deletes marked text
(show-paren-mode t)			; match parentheses
(add-hook 'text-mode-hook 'turn-on-auto-fill) ; wrap long lines in text mode
;(tool-bar-mode nil)			; hide the toolbar

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

;; Following the "source is real" philosophy put forward by ESS, one
;; should not need the command history and should not save the
;; workspace at the end of an R session. Hence, both options are
;; disabled here.
(setq-default inferior-R-args "--no-restore-history --no-save ")

;; Set code indentation following the standard in R sources.
(setq-default c-default-style "bsd")
(setq-default c-basic-offset 4)
(add-hook 'ess-mode-hook
	  '(lambda()
	     (ess-set-style 'C++ 'quiet)
	     (add-hook 'write-file-functions
                           (lambda ()
                             (ess-nuke-trailing-whitespace)))))
(setq ess-nuke-trailing-whitespace-p t)

;; Path to R executable. Uncomment and edit as needed if R is
;; installed in such an unusual place that ESS can't find it. (And
;; then keep updating with each R update!)
;(setq-default inferior-R-program-name
;              "c:/program files/r/r-2.7.1/bin/rterm.exe")

;; Path to S-Plus GUI; needed only to use ESS with the S-Plus GUI.
;(setq-default inferior-S+6-program-name
;              "c:/program files/insightful/splus7/cmd/splus.exe")
;(custom-set-variables '(inferior-ess-start-args "-j"))

;; Path to lightweight Sqpe.exe; needed only to use S-Plus in the
;; Emacs window.
;(setq-default inferior-Sqpe+6-program-name
;              "c:/program files/insightful/splus7/cmd/sqpe.exe")
;(setq-default inferior-Sqpe+6-SHOME-name
;              "c:/program files/insightful/splus7/")

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
;;; Use Aspell for spell checking
;;;
