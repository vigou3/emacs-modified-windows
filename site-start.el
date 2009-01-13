;;; =========================
;;;  Site configuration file
;;; =========================

;;; Nice options to have On by default
(global-font-lock-mode t)		; syntax highlighting
(transient-mark-mode t)			; sane select (mark) mode
(delete-selection-mode t)		; entry deletes marked text
(show-paren-mode t)			; match parentheses
(add-hook 'text-mode-hook 'turn-on-auto-fill) ; wrap long lines in text mode
;(tool-bar-mode nil)			; hide the toolbar

;;; Activate w32-winprint
(require 'w32-winprint)

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
;              "c:/program files/r/r-2.5.1/bin/rterm.exe")

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


;;; AUCTeX
;;;
;;; We assume that MiKTeX (http://www.miktek.org) is used for
;;; TeX/LaTeX. Otherwise, change the (require ...) line as per the
;;; AUCTeX documentation.
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(require 'tex-mik)

;;; Ispell
;;;
;;; Use Aspell for spell checking.
