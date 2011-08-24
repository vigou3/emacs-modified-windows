;;; w32-winprint.el --- MS Windows printing

;; Copyright (C) 2004 by Lennart Borgman

;; Author:     Lennart Borgman <lennart DOT borgman DOT 073 AT student DOT lu DOT se>
;; Maintainer: Lennart Borgman <lennart DOT borgman DOT 073 AT student DOT lu DOT se>
;; Created: 2004-07-26
;; Version: 0.7
;; Keywords: extensions convenience

;; This file is not part of GNU Emacs

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; w32-winprint.el adds function to print through the printer setup as
;; the default printer under MS Windows.  It adds some entries on the
;; File menu for this:
;;
;;   - Print Buffer with Notepad (B+W)
;;   - Print Region with Notepad (B+W)
;;   - Print Buffer with Web Browser (Color)
;;   - Print Region with Web Browser (Color)
;;
;; The default print entries in Emacs on the File menu are removed.
;;
;; To use this package put in your load-path and do
;;   (require 'w32-winprint)
;;
;; This file also defines a protected form of w32-shell-execute
;; that can be used for other things as well (for example showing
;; local html files or files on the Internet in the users web
;; browser).
;;
;; If not run on MS Windows this file does nothing except gives a message.

(if (not (string-match "i386" system-configuration))
    (message "w32-print.el can only be used on MS Windows")

  (defgroup w32-winprint nil
    "w32-print lets Emacs print using the printers setup in MS Windows.
The normal print dialogs are shown.  Printing in colors is supported
if �htmlize.el is found, then using the function `htmllize-buffer'."
    :group 'printing
    :prefix "w32-winprint-")


  (require 'htmlize nil t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; ShellExecute enhancement

  (defun w32-winprint-show-waiting(msg sec)
    "Show user Emacs is waiting"
    (let ((lsec sec)(lmsg msg))
      (while (> lsec 0)
	(message lmsg)
	(sleep-for 1)
	(setq lmsg (concat lmsg "."))
	(setq lsec (- lsec 1)))
      (message "")))

  (defcustom w32-winprint-shell-execute-wait 5
    "Default number of seconds to show waiting message after calling
ShellExecute."
    :group 'w32-winprint)

  (defun w32-winprint-shell-execute(verb file-name
					 &optional parameters show-flag)
    "Wrapper around w32-shell-execute that gives a message on error
instead of signaling the error. It also gives a waiting message in the
bottom of the screen."
    (condition-case err
	(progn
	  (let ((msg (format "Asked Explorer to %s %s " verb file-name)))
	    (message (concat msg "(locked? popup minimized?)"))
	    (w32-shell-execute verb file-name parameters (if show-flag show-flag 1))
	    (w32-winprint-show-waiting msg w32-winprint-shell-execute-wait)))
      (error (let ((msg (car (cdr err))))
	       ;;(message "orig err: %s" msg)
	       (setq msg (replace-regexp-in-string "ShellExecute failed: " "" msg))
	       (setq msg (replace-regexp-in-string "[\r\n ]*$" "" msg))
	       (setq msg (replace-regexp-in-string "this operation"
						   (concat "'" verb "'") msg))
	       (message msg)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; Printing

  (defvar w32-winprint-kill-buffers t
    "For debbugging purpose. If false keeps the temporary buffers used
for printing.")

  (defun w32-winprint-gettemp-print-name(html)
    "Get a temp file name for printing"
    (expand-file-name (concat "~/temp-print." (if html "html" "tmp"))))


  (defun w32-winprint-print-file-notepad(file-name)
    "Print file with notepad"
    (message "w32-winprint-shell-execute open notepad.exe (concat /p %s" file-name)
    (w32-winprint-shell-execute "open" "notepad.exe" (concat "/p " file-name)
				))

  (defun w32-winprint-print-part-notepad(start-point end-point)
    "Print current buffer part with notepad"
    (setq file (w32-winprint-gettemp-print-name nil))
    (save-excursion
      (let (deactivate-mark)
	(copy-to-buffer "*print-temp*" start-point end-point)
	(set-buffer "*print-temp*")
	(write-file file nil)
	(w32-winprint-print-buffer-notepad))))


  (defun w32-winprint-print-region-notepad()
    "Print current region with notepad"
    (interactive)
    (let ((start (mark)) (end (point)))
      (or (<= start end)
	  (setq start (prog1 end (setq end start))))
      (w32-winprint-print-part-notepad start end)))


  (defun w32-winprint-print-buffer-notepad()
    "Print whole current buffer with notepad"
    (interactive)
    (let ((file (buffer-file-name (current-buffer))))
      (if (not file)
	  (progn
	    (save-excursion
	      (widen)
	      (w32-winprint-print-part-notepad (point-min) (point-max))))
	(if (buffer-modified-p)
	    (let ((use-dialog-box nil))
	      (if (y-or-n-p "File is modified. Save before printing? ")
		  (save-buffer))))
	(w32-winprint-print-file-notepad file))))




  ;;;;;; Colored printing is available only if htmlize can be used:
  (if (featurep 'htmlize)
      (progn

	(defcustom w32-winprint-print-htmlize-verb "print"
	  "The verb used for printing should normally be 'print'.  If you want
to test you can set it to 'open' instead which should open the
htmlized of the printed object in your web browser instead of printing
it."
	  :type 'string
	  :group 'w32-winprint)

	(defun w32-winprint-print-htmlize(whole-buffer)
	  "HTML printing by converting to html, writing to a temporary
file and sending the temporary html file to printer by calling
Explorer.  The verb used can be customized, for more info see
`w32-winprint-print-htmlize-verb'."
	  (interactive)  
	  (message "Creating a html version for printing ...")
	  (save-excursion

	    (let (deactivate-mark (start (mark))(end (point)))
	      (if (>= start end) (setq start (point) end (mark)))
	      (let ((html-temp-buffer 
		     (if whole-buffer
			 (htmlize-buffer (current-buffer))
		       (htmlize-region start end)))
		  (file (w32-winprint-gettemp-print-name t)))
	      (set-buffer html-temp-buffer)
	      (write-file file nil)
	      (w32-winprint-shell-execute w32-winprint-print-htmlize-verb (buffer-file-name))
	      (if w32-winprint-kill-buffers (kill-buffer html-temp-buffer))))))

	(defun w32-winprint-print-buffer-htmlize()
	  "Print buffer as html"
	  (interactive)
	  (w32-winprint-print-htmlize t))

	(defun w32-winprint-print-region-htmlize()
	  "Print region as html"
	  (interactive)
	  (w32-winprint-print-htmlize nil))

	))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; Menus

  (defun w32-winprint-fix-files-menu()
    "Remove old print entries from the Files menu and add w32-print
entries instead"

    (if (featurep 'htmlize)
	(progn

	  (define-key-after menu-bar-files-menu [print-region-htmlize]
	    (cons "Print Region with Web Browser (Color)" 'w32-winprint-print-region-htmlize)
	    'print-buffer)
	  (define-key-after menu-bar-files-menu [print-buffer-htmlize]
	    (cons "Print Buffer with Web Browser (Color)" 'w32-winprint-print-buffer-htmlize)
	    'print-buffer)

	  ))


    (define-key-after menu-bar-files-menu [print-region-notepad]
      (cons "Print Region with Notepad (B+W)" 'w32-winprint-print-region-notepad)
      'print-buffer)
    (define-key-after menu-bar-files-menu [print-buffer-notepad]
      (cons "Print Buffer with Notepad (B+W)" 'w32-winprint-print-buffer-notepad)
      'print-buffer)
    (put 'w32-winprint-print-region-htmlize 'menu-enable 'mark-active)
    (put 'w32-winprint-print-region-notepad 'menu-enable 'mark-active)
    (define-key menu-bar-files-menu [print-buffer] nil)  
    (define-key menu-bar-files-menu [print-region] nil)  
    (define-key menu-bar-files-menu [ps-print-buffer] nil)  
    (define-key menu-bar-files-menu [ps-print-region] nil)  
    (define-key menu-bar-files-menu [ps-print-buffer-faces] nil)  
    (define-key menu-bar-files-menu [ps-print-region-faces] nil)  
    )

  (w32-winprint-fix-files-menu)

  (provide 'w32-winprint)
  )

;;; w32-winprint.el ends here

