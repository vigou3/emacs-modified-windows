;;; default.el --- Default configuration for Emacs Modified for Windows
;;
;; This file is used mainly to load custom extensions. It is loaded
;; *after* any user and site configuration files.
;;
;; Copyright (C) 2015-2019 Vincent Goulet
;;
;; Author: Vincent Goulet
;;
;; This file is part of Emacs Modified for Windows
;; https://gitlab.com/vigou3/emacs-modified-windows

;; Emacs for Windows Modified is free software; you can
;; redistribute it and/or modify it under the terms of the GNU General
;; Public License as published by the Free Software Foundation; either
;; version 3, or (at your option) any later version.
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
;;; Version number of Emacs Modified
;;;
;; Define variable and function 'emacs-modified-version'
(require 'version-modified)

;;;
;;; tabbar
;;;
;; Start with (tabbar-mode) in ~/.emacs
;; Toggle with (tabbar-mode -1)
;; tabbar v2.2 was cloned from https://github.com/dholm/tabbar
;; tabbar-mode's inclusion in Vincent's distribution is maintained by 
;; Rodney Sparapani <rsparapa@mcw.edu>
(require 'tabbar)

(defun tabbar-buffer-groups ()
  "Return the list of group names the current buffer belongs to.
Return a list of one element based on major mode."
  (list
   (cond
    ((member (buffer-name) '("*GNU Emacs*" "*ESS*" "*Messages*" "*Warnings*"))
     "Bury" )
    ((member (buffer-name) '("*S+6*" "*R*" "*R:2*" "*R:3*" "*R:4*" "*R:5*" "*R:6*" "*R:7*" "*R:8*" "*R:9*"))
     "ESS[S]" ) 
    ((string-match "\*R:.*\*" (buffer-name)) "ESS[S]" ) 
    ((memq major-mode '(ess-help-mode ess-transcript-mode)) "ESS[S]" )
    ((member mode-name '("ESS[LST]")) "ESS[LST]" )
   ((or (get-buffer-process (current-buffer))
         ;; Check if the major mode derives from `comint-mode' or
         ;; `compilation-mode'.
         (tabbar-buffer-mode-derived-p
          major-mode '(comint-mode compilation-mode)))
     "Process" )
    ((member (buffer-name) '("*shell*")) "Process" )
    ((memq major-mode '(Man-mode fundamental-mode)) "Process" )
    ((member (buffer-name) '("*scratch*")) "Emacs-Lisp" )
    ((eq major-mode 'dired-mode) "Dired" )
    ((member (buffer-name) '("*GNU Emacs*")) "Emacs-Lisp" )
    ((memq major-mode '(help-mode apropos-mode Info-mode)) "Emacs-Lisp" )
    ((memq major-mode
           '(rmail-mode
             rmail-edit-mode vm-summary-mode vm-mode mail-mode
             mh-letter-mode mh-show-mode mh-folder-mode
             gnus-summary-mode message-mode gnus-group-mode
             gnus-article-mode score-mode gnus-browse-killed-mode))
     "Mail" )
    ((or     
     (member mode-name '("DocView"))
;             '("LaTeX" "DocView"))
     (member (buffer-name) '("*TeX Help*"))
     (memq major-mode '(plain-tex-mode latex-mode bibtex-mode)))
     "LaTeX" )
    (t
     ;; Return `mode-name' if not blank, `major-mode' otherwise.
     (if (and (stringp mode-name)
              ;; Take care of preserving the match-data because this
              ;; function is called when updating the header line.
              (save-match-data (string-match "[^ ]" mode-name)))
         mode-name
       (symbol-name major-mode))
     ))))
