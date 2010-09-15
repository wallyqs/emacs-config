(require 'cl)

(defun pink-bliss-save-or-open ()
  "Save the current buffer or open a file."
  (interactive)
  (if (buffer-modified-p)
      (save-buffer)
    (call-interactively 'find-file)))

(defun color-theme-pink-bliss ()
  "Happy kitsch in pink and yellow."
  (interactive)
  ;; toolbar -- but only if the pink gnu was installed!
  (when (find-image '((:type xpm :file "pink-gnu.xpm")))
    (unless tool-bar-mode (tool-bar-mode 1))
    (setq tool-bar-map (make-sparse-keymap))
    (tool-bar-add-item "pink-gnu" 'pink-bliss-save-or-open 'pink-defun))
  ;; variables
  (setq CUA-mode-read-only-cursor-color "dark grey"
	help-highlight-face 'info-xref
	list-matching-lines-buffer-name-face 'bold
	rcirc-colors pink-bliss-foreground-colors)
  ;; faces
  (dolist (element
	   '((default ((t ( :background "misty rose" :foreground "magenta4"))))
	     (button ((t (:bold t))))
	     (fringe ((t (:background "hot pink"))))
	     (menu ((t (:background "pink" :foreground "violet red"))))
	     (modeline ((t (:background "pink" :foreground "purple"
			    :box (:line-width 1 :style released-button)))))
	     (mode-line-inactive ((t (:background "pink" :foreground "orchid"
				      :box (:line-width 1
					    :style released-button)))))
	     (minibuffer-prompt ((t (:foreground "deep pink"))))
	     (tool-bar ((t (:background "pink"
			    :box (:line-width 1 :style released-button)))))
	     (tooltip ((t (:background "lemon chiffon"
			   :foreground "violet red"))))
	     (region ((t (:background "white"))))
	     ;; isearch
	     (isearch ((t (:foreground "pink" :background "red"))))
	     (isearch-lazy-highlight-face ((t (:foreground "red"))))
	     ;; info-mode
	     (header-line ((t (:background "deep pink" :foreground "pink"))))
	     ;; calendar
	     (calendar-today-face ((t (:foreground "lemon chiffon"))))
	     (diary-face ((t (:bold t :foreground "yellow"))))
	     (holiday-face ((t (:bold t :foreground "peru"))))
	     ;; font-lock
	     (font-lock-builtin-face ((t (:foreground "orchid"))))
	     (font-lock-comment-delimiter-face ((t (:foreground "coral"))))
	     (font-lock-comment-face ((t (:foreground "salmon"))))
	     (font-lock-constant-face ((t (:foreground "orchid"))))
	     (font-lock-doc-face ((t (:foreground "coral"))))
	     (font-lock-function-name-face ((t (:foreground "deep pink"))))
	     (font-lock-keyword-face ((t (:foreground "purple"))))
	     (font-lock-negation-char-face ((t (:foreground "red"))))
	     (font-lock-preprocessor-face ((t (:foreground "pink"))))
	     (font-lock-string-face ((t (:foreground "pale violet red"))))
	     (font-lock-type-face ((t (:foreground "light slate blue"))))
	     (font-lock-variable-name-face ((t (:foreground "hot pink"))))
	     (font-lock-warning-face ((t (:bold t :foreground "red"))))
	     ;; cperl
	     (cperl-array-face ((t (:bold t :foreground "tomato"))))
	     (cperl-hash-face  ((t (:bold t :foreground "chocolate"))))
	     (cperl-nonoverridable-face  ((t (:foreground "red"))))
	     ;; makefiles
	     (makefile-shell-face  ((t (:background "linen"))))))
    (let ((face (car element))
	  (spec (nth 1 element)))
      (unless (facep face)
	(make-face face))
      (face-spec-set face spec))))

(defvar pink-bliss-foreground-colors
  (let ((candidates)
	;; (red-limit #xe000)
	(green-limit #xed00)
	(both-limit #xa000))
    (dolist (item color-name-rgb-alist)
      (destructuring-bind (color red green blue) item
	(when (and (not (color-gray-p color))
		   ;; (< red red-limit)
		   (< green green-limit)
		   (not (and (> red both-limit)
			     (> green both-limit))))
	  (setq candidates (cons color candidates)))))
    candidates)
  "Colors to use for nicks in rcirc, for example.

To check out the list, evaluate
\(list-colors-display pink-bliss-foreground-colors).")

(provide 'color-theme-pink-bliss)
