;;; vc-svn17.el --- Subversion 1.7 support for vc-svn on Emacs23

;; Copyright (C) 2012  Taiki SUGAWARA <buzz.taiki@gmail.com>

;; Author: Taiki SUGAWARA <buzz.taiki@gmail.com>
;; Maintainer: Taiki SUGAWARA <buzz.taiki@gmail.com>
;; Version: 0.01
;; URL: https://github.com/buzztaiki/vc-svn17-el

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package provides subversion 1.7 support for vc-svn on Emacs23.
;; 
;; To use this package, put followings in your .emacs:
;; 
;;     (require 'vc-svn17)

;;; Code:

(require 'vc-svn)

(defmacro vc-svn17-defun (name args &rest body)
  (declare (indent defun))
  `(when (<= emacs-major-version 23)
     ,(if (stringp (car body))
	  `(defun ,name ,args ,(car body) ,@(cdr body))
	`(defun ,name ,args nil ,@body))))

(defmacro vc-svn17-repfun (name args &rest body)
  (declare (indent defun))
  `(when (<= emacs-major-version 23)
     (defadvice ,name (around vc-svn17 ,args activate)
       (setq ad-return-value ,@body))))


(vc-svn17-defun vc-svn-root (file)
  (vc-find-root file vc-svn-admin-directory))

(vc-svn17-repfun vc-svn-registered (file)
  (when (vc-svn-root file)
    (with-temp-buffer
      (cd (file-name-directory file))
      (let* (process-file-side-effects
	     (status
	      (condition-case nil
		  ;; Ignore all errors.
		  (vc-svn-command t t file "status" "-v")
		(error nil))))
	(when (eq 0 status)
	  (let ((parsed (vc-svn-parse-status file)))
	    (and parsed (not (memq parsed '(ignored unregistered))))))))))

(vc-svn17-repfun vc-svn-responsible-p (file)
  (vc-svn-root file))

(vc-svn17-repfun vc-svn-repository-hostname (dirname)
  (with-temp-buffer
    (let (process-file-side-effects)
      (vc-svn-command t t dirname "info"))
    (goto-char (point-min))
    (when (re-search-forward "^URL: *\\(.*\\)" nil t)
      (match-string 1))))

(provide 'vc-svn17)
;;; vc-svn17.el ends here
