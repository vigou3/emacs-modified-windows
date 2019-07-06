;;; version-modified.el --- version number of Emacs Modified for Windows
;;
;; Copyright (C) 2013-2017 Vincent Goulet
;;
;; Author: Vincent Goulet (based on version.el from GNU Emacs sources)
;;
;; This file is part of Emacs Modified for Windows
;; https://gitlab.com/vigou3/emacs-modified-windows

;; Emacs Modified for Windows is free software; you can redistribute
;; it and/or modify it under the terms of the GNU General Public
;; License as published by the Free Software Foundation; either
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

(defconst emacs-modified-version '2
  "Revision number of this version of Emacs Modified")

(defun emacs-modified-version (&optional here)
  "Return string describing the version of Emacs Modified that is running.
If optional argument HERE is non-nil, insert string at point."
  (interactive "P")
  (let ((version-string
         (format "GNU Emacs %s-modified-%s"
                 emacs-version
                 emacs-modified-version)))
    (if here
        (insert version-string)
      (if (called-interactively-p 'interactive)
          (message "%s" version-string)
        version-string))))

(provide 'version-modified)
