;;==============================================;;
;;==============================================;;
;;                                              ;;
;;        Ampl mode for the Emacs editor.       ;;
;;                                              ;;
;;   Dominique Orban.     Chicago, March 2003.  ;;
;;                                              ;;
;;   orban@ece.northwestern.edu                 ;;
;;                                              ;;
;;==============================================;;
;;==============================================;;

;; Author: Dominique Orban <orban@ece.northwestern.edu>
;; Keywords: Ampl
;; Version: 0.1
;; Time stamp: "Sun Mar 23 20:06:35 PST 2003"

;; Purpose:    Provides syntax highlighting and basic
;;  indentation for models written in Ampl. Ampl is a
;;  modeling language for optimization programs.  See
;;  www.ampl.com for more information.
;;  This file is  still under  development,  features
;;  will be added as time allows. One of these, which
;;  I hope to  provide in the  not-too-distant future
;;  is the ability to run an Ampl process in an Emacs
;;  window to facilitate model debugging and running.

;; If you find this mode useful, please let me know
;; <orban@ece.northwestern.edu>

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is NOT part of GNU Emacs.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with the Emacs program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;; ======================  C O D E  ================================

;;==============
;; Version number and author
(defconst ampl-mode-version-number "0.1"
  "Version of ampl-mode.el")

(defconst ampl-mode-author "Dominique Orban"
  "Author of ampl-mode.el")
;;
;;==============


;; ====================== S E T U P =================================

;; Ampl major mode setup
(defvar ampl-mode-hook nil)
(defvar ampl-mode-map (make-keymap) "Keymap for Ampl major mode")

;; Load default keymap if nil
(if ampl-mode-map nil
  (setq ampl-mode-map (make-keymap)))

;; Define a simple keymap to auto-close brackets and quotes
(let ((map ampl-mode-map))
  (define-key map "("     'ampl-insert-parens)
  (define-key map "["     'ampl-insert-sqbrackets)
  (define-key map "{"     'ampl-insert-curlies)
  (define-key map "\""    'ampl-insert-double-quotes)
  (define-key map "'"     'ampl-insert-single-quotes)
  (define-key map "\C-co" 'ampl-insert-comment) )

;; Files whose extension is .mod will be edited in ampl mode
(setq auto-mode-alist
      (append
       '(("\\(.mod\\|.dat\\|.ampl\\)'" . ampl-mode))
     auto-mode-alist))

(autoload 'ampl-mode "Ampl" "Entering Ampl mode..." t)

;; ============= K E Y W O R D   H I G H L I G H T I N G ============

;; Keyword highlighting: model and data statements
;; may be followed by a name, must be followed by a semicolon.
(defconst ampl-font-lock-model-data
  (list '( "\\(data\\|model\\)\\(.*;\\)" 1 font-lock-builtin-face keep t))
  "Reserved keywords highlighting")

(defconst ampl-font-lock-model-data-names
  (append ampl-font-lock-model-data
  (list '( "\\(data\\|model\\)\\(.*\\)\\(;\\)" . (2 font-lock-constant-face keep t))))
  "Model and data filenames highlighting")

;; Other reserved keywords
(defconst ampl-font-lock-keywords-reserved
  (append ampl-font-lock-model-data-names
	  (list '("\\(^\\|[ \t]+\\|[({\[][ \t]*\\)\\(I\\(N\\(OUT\\)?\\|nfinity\\)\\|LOCAL\\|OUT\\|a\\(nd\\|r\\(c\\|ity\\)\\)\\|b\\(inary\\|y\\)\\|c\\(ard\\|heck\\|ircular\\|o\\(eff\\|mplements\\|ver\\)\\)\\|d\\(ata\\|efault\\|i\\(ff\\|men\\|splay\\)\\)\\|e\\(lse\\|xists\\)\\|f\\(irst\\|orall\\|rom\\)\\|i\\(n\\(clude\\|dexarity\\|te\\(ger\\|r\\(val\\)?\\)\\)\\|n\\)\\|l\\(ast\\|e\\(ss\\|t\\)\\)\\|m\\(aximize\\|ember\\|inimize\\)\\|n\\(extw?\\|o\\(de\\|t\\)\\)\\|o\\(bj\\|ption\\|r\\(d\\(0\\|ered\\)?\\)?\\)\\|p\\(aram\\|r\\(evw?\\|intf\\)\\)\\|re\\(peat\\|versed\\)\\|s\\(\\.t\\.\\|et\\(of\\)?\\|olve\\|u\\(bject to\\|ffix\\)\\|ymbolic\\)\\|t\\(able\\|hen\\|o\\)\\|un\\(ion\\|til\\)\\|var\\|w\\(hile\\|ithin\\)\\)\\({\\|[ \t]+\\|[:;]\\)" 2 font-lock-builtin-face keep t)))
  "Reserved keywords highlighting-1")

;; 'if' is a special case as it may take the forms
;; if(i=1), if( i=1 ), if ( i=1 ), etc.
(defconst ampl-font-lock-keywords-reserved2
  (append ampl-font-lock-keywords-reserved
	  (list '("\\(^\\|[ \t]+\\|[({][ \t]*\\)\\(if\\)\\([ \t]*(\\|[ \t]+\\)" . (2 font-lock-builtin-face keep t))))
  "Reserved keywords highlighting-2")

;; 'Infinity' is another special case as it may
;; appear as -Infinity...
(defconst ampl-font-lock-keywords-reserved3
  (append ampl-font-lock-keywords-reserved2
	  (list '("\\(^\\|[ \t]+\\|[({\[][ \t]*\\)\\(-[ \t]*\\)\\(Infinity\\)\\([ \t]*(\\|[ \t]+\\)" . (3 font-lock-builtin-face keep t))))
  "Reserved keywords highlighting-3")

;; Built-in operators highlighting
;; must be followed by an opening parenthesis
(defconst ampl-font-lock-keywords-ops
  (append ampl-font-lock-keywords-reserved3
	  (list '("\\(a\\(bs\\|cosh?\\|lias\\|sinh?\\|tan[2h]?\\)\\|c\\(eil\\|os\\|time\\)\\|exp\\|floor\\|log\\(10\\)?\\|m\\(ax\\|in\\)\\|precision\\|round\\|s\\(inh?\\|qrt\\)\\|t\\(anh?\\|ime\\|runc\\)\\)\\([ \t]*(\\)" 1 font-lock-function-name-face t)))
  "Built-in operators highlighting")

;; Random number generation functions
;; must be followed by an opening parenthesis
(defconst ampl-font-lock-keywords-rand
  (append ampl-font-lock-keywords-ops
	  (list '("\\(Beta\\|Cauchy\\|Exponential\\|Gamma\\|Irand224\\|Normal\\(01\\)?\\|Poisson\\|Uniform\\(01\\)?\\)\\([ \t]*(\\)" 1 font-lock-function-name-face t)))
  "Random number generation functions")

;; Built-in operators with iterators
;; must be followed by an opening curly brace
(defconst ampl-font-lock-keywords-iterate
  (append ampl-font-lock-keywords-rand
	  (list '("\\(prod\\|sum\\)\\([ \t]*{\\)" 1 font-lock-function-name-face t)))
  "Built-in operators with iterators")

;; Constants, parameters and names
;; follow the keywords param, let, set, var, minimize, maximize, option or 'subject to'
(defconst ampl-font-lock-constants1
  (append ampl-font-lock-keywords-iterate
	  (list '("\\(^[ \t]*\\)\\(display\\|let\\|m\\(aximize\\|inimize\\)\\|option\\|param\\|s\\(\\.t\\.\\|et\\|ubject to\\)\\|var\\)\\([ \t]*\\)\\([a-zA-Z0-9\-_]+\\)\\([ \t]*.*[;:]\\)" 6 font-lock-constant-face t)))
  "Constants, parameters and names")

;; Constants may also be defined after a set specification
;; This does not involve 'option'
;; e.g. let {i in 1..5} x[i] := 0;
(defconst ampl-font-lock-constants2
  (append ampl-font-lock-constants1
	  (list '("\\(^[ \t]*\\)\\(display\\|let\\|m\\(aximize\\|inimize\\)\\|param\\|s\\(\\.t\\.\\|et\\|ubject to\\)\\|var\\)\\([ \t]*\\)\\({[a-zA-Z0-9\-_\. \t]+}\\)\\([ \t]*\\)\\([a-zA-Z0-9\-_]+\\)\\([ \t]*.*[;:]\\)" 8 font-lock-constant-face t)))
  "Constants, parameters and names")

;; Comments
;; start with a hash, end with a newline
(defconst ampl-font-lock-comments
  (append ampl-font-lock-constants2
	  (list '( "\\(#\\).*$" 0 font-lock-comment-face t)))
  "Comments")

;; Define default highlighting level
(defvar ampl-font-lock-keywords ampl-font-lock-comments
  "Default syntax highlighting level in Ampl mode")

;; ==================== I N D E N T A T I O N ====================

;; Indentation --- Fairly simple for now
(defun ampl-indent-line ()
  "Indent current line as Ampl code"
  (interactive)
  (beginning-of-line)

  ;; Flush left at beginning of buffer
  (if (bobp)
      (indent-line-to 0)

    (let ((not-indented t) cur-indent)
    
      ;; Base case: Keywords are flushed left
      (if (looking-at "^[ \t]*\\(data\\|let\\|m\\(aximize\\|inimize\\|odel\\)\\|param\\|s\\(et\\|olve\\|ubject to\\)\\|var\\)")
	  (progn
	    (setq cur-indent 0)
	    (setq not-indented nil))

	;; Comments are indented like the preceding line
	(if (looking-at "^[ \t]*#")
	    (progn
	      (save-excursion
		(forward-line -1)
		(setq cur-indent (current-indentation))
		(setq not-indented nil)))

	;; Base indentation of current line on the form of preceding line
	  (save-excursion
	    (while not-indented
	      (forward-line -1)

	      ;; If the preceding line ends with a semicolon, indent less
	      (if (looking-at ";[ \t]*$")
		  (progn
		    (setq cur-indent (- (current-indentation) default-tab-width))
		    ;; Do not try to indent past the left margin
		    (if (< cur-indent 0)
			(setq cur-indent 0))
		    (setq not-indented nil))

		;; If a keyword precedes, indent more
		(if (looking-at "^[ \t]*\\(data\\|let\\|m\\(?:aximize\\|inimize\\|odel\\)\\|param\\|s\\(?:et\\|olve\\|ubject to\\)\\|var\\)")
		    (progn
		      (setq cur-indent (+ (current-indentation) default-tab-width))
		      (setq not-indented nil))
		  (if (bobp)
		      (setq not-indented nil)) ))))))

      ;; Indent current line to level given by cur-indent
      ;; If we didn't see an indentation hint, then allow no indentation
      (if cur-indent
	  (indent-line-to cur-indent) 
	(indent-line-to 0)))))

;; ================= U S E R   C O M M A N D S ======================

(defvar ampl-auto-close-parenthesis t
  "# Automatically insert closing parenthesis if non-nil")

(defvar ampl-auto-close-brackets t
  "# Automatically insert closing square bracket if non-nil")

(defvar ampl-auto-close-curlies t
  "# Automatically insert closing curly brace if non-nil")

(defvar ampl-auto-close-double-quote t
  "# Automatically insert closing double quote if non-nil")

(defvar ampl-auto-close-single-quote t
  "# Automatically insert closing single quote if non-nil")

(defvar ampl-user-comment
  "#####
##  %       
#####
"
  "# User-defined comment template." )

;; ====================== S Y N T A X   T A B L E ==================

;; Syntax table for Ampl major mode
(defvar ampl-mode-syntax-table nil
  "Syntax table for Ampl mode.")

(defun ampl-create-syntax-table ()
  (if ampl-mode-syntax-table
      ()
    (setq ampl-mode-syntax-table (make-syntax-table))
    (set-syntax-table ampl-mode-syntax-table)

    ;; Indicate that underscore may be part of a word
    (modify-syntax-entry ?_ "w" ampl-mode-syntax-table)

    ;; Comments start with a hash and end with a newline
    (modify-syntax-entry ?# "<" ampl-mode-syntax-table)
    (modify-syntax-entry ?\n ">" ampl-mode-syntax-table)
    ))

;; ================= A M P L   M A J O R   M O D E ===============

;; Definition of Ampl major mode
(defun ampl-mode ()
  "Major mode for editing Ampl models"
  (interactive)
  (kill-all-local-variables)

  ;; Load keymap
  (use-local-map ampl-mode-map)

  ;; Load syntax table
  (ampl-create-syntax-table)

  ;; Highlight Ampl keywords
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults
	'(ampl-font-lock-keywords))

  ;; Indent Ampl commands
  (make-local-variable 'indent-line-function)
  (setq indent-line-function 'ampl-indent-line)

  ;; Application of user commands
  ;; Comment insertion.
  (defun ampl-insert-comment ()
    "Insert a comment template defined by `ampl-user-comment'."
    (interactive)
    (let ((point-a (point))
	  (use-comment ampl-user-comment)
	  point-b point-c)
      (insert ampl-user-comment)
      (setq point-b (point))

      (goto-char point-a)
      (if (re-search-forward "%" point-b t)
	  (progn
	    (setq point-c (match-beginning 0))
	    (replace-match ""))
	(goto-char point-b))
      ))

  (defun ampl-insert-parens (arg)
    "Insert parenthesis pair."
    (interactive "p")
    (if ampl-auto-close-parenthesis
	(progn
	  (insert "()")
	  (backward-char 1))
      (insert "(")))

  (defun ampl-insert-sqbrackets (arg)
    "Insert square brackets pair."
    (interactive "p")
    (if ampl-auto-close-brackets
	(progn
	  (insert "[]")
	  (backward-char 1))
      (insert "[")))

  (defun ampl-insert-curlies (arg)
    "Insert curly braces pair."
    (interactive "p")
    (if ampl-auto-close-curlies
	(progn
	  (insert "{}")
	  (backward-char 1))
      (insert "{")))

  (defun ampl-insert-double-quotes (arg)
    "Insert double quotes pair."
    (interactive "p")
    (if ampl-auto-close-double-quote
	(progn
	  (insert "\"\"")
	  (backward-char 1))
      (insert "\"")))

  (defun ampl-insert-single-quotes (arg)
    "Insert single quotes pair."
    (interactive "p")
    (if ampl-auto-close-single-quote
	(progn
	  (insert "''")
	  (backward-char 1))
      (insert "'")))

  ;; End of user commands

  (setq major-mode 'ampl-mode)
  (setq mode-name "Ampl")
  (run-hooks 'ampl-mode-hook))

(provide 'ampl-mode)


;; ========================  E N D   O F   A M P L . E L  ==========================
