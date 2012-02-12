;; color-theme-hrehf-dark.el, Revision 1
;; Copyright (C) 2011  Hauke Rehfeld
;; 
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; color-theme-gruber-dark.el
;; Revision 1
;;
;; Copyright (C) 2009-2010 Jason R. Blevins
;;
;; Permission is hereby granted, free of charge, to any person
;; obtaining a copy of this software and associated documentation
;; files (the "Software"), to deal in the Software without
;; restriction, including without limitation the rights to use,
;; copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the
;; Software is furnished to do so, subject to the following
;; conditions:
;;
;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
;; OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
;; HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
;; WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
;; FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
;; OTHER DEALINGS IN THE SOFTWARE.


(require 'color-theme)

(defun color-theme-hrehf-dark ()
  "A dark, stylish, optimized color theme loosely based on Gruber Darker by Jason R. Blevins."
  (interactive)
  (color-theme-install
   '(color-theme-hrehf-dark
     ((foreground-color . "#ddd")
      (background-color . "#222224")
      (background-mode . dark)
      (cursor-color . "#fd3")
      (mouse-color . "#fff")
      )

     ;; Standard font lock faces
     (default ((t (nil))))
     (font-lock-comment-face ((t (:foreground "#cb6"))))
     (font-lock-comment-delimiter-face ((t (:foreground "#874"))))
     (font-lock-doc-face ((t (:foreground "#ff0"))))
	 (font-lock-doc-string-face ((t (:foreground "#ca5"))))
     (font-lock-string-face ((t (:foreground "#8e5"))))
     (font-lock-keyword-face ((t (:foreground "#f8b"))))
     (font-lock-builtin-face ((t (:foreground "#ed4"))))
     (font-lock-function-name-face ((t (:foreground "#fff" :underline "#999"))))
     (font-lock-variable-name-face ((t (:foreground "#bbeecc"
                                                    :box nil
                                        ;:box (:line-width 1 :color "#8EDDD2")
                                                    ))))
     (font-lock-preprocessor-face ((t (:foreground "#ccc"))))
     (font-lock-constant-face ((t (:foreground "#bfc"))))
     (font-lock-type-face ((t (:foreground "#eea"))))
     (font-lock-warning-face ((t (:foreground "#f44"))))
     (font-lock-reference-face ((t (:foreground "#f0f"))))
     (font-lock-negation-char-face ((t (:foreground "#949" :overline nil))))

     (font-lock-regexp-grouping-backslash ((t (:foreground "#9a8"))))
     (font-lock-regexp-grouping-construct ((t (:weight bold :foreground "#af7"))))

     (trailing-whitespace ((t (:underline "#733" ))))
     (link ((t (:foreground "#44e" :underline t))))

     ;; Search
     (isearch ((t (:foreground "#000" :background "#8ef"))))
     (isearch-lazy-highlight-face ((t (:foreground "#f4f4ff" :background "#5f627f"))))
     (isearch-fail ((t (:background nil :foreground "#f43841"))))

     ;; User interface
     (fringe ((t (:background "#141414" :foreground "#999"))))
     (border ((t (:background "#0f0" :foreground "#f00"))))
     (mode-line ((t (:background "#556" :foreground "#aaa"))))
     (mode-line-buffer-id ((t (:foreground "#eee" :slant italic))))
     (mode-line-inactive ((t (:background "#334" :foreground "#667"))))
     (minibuffer-prompt ((t (:foreground "#bbb"))))
     (region ((t (:background "#484848"))))
     (secondary-selection ((t (:background "#484951" :foreground "#F4F4FF"))))
     (tooltip ((t (:background "#52494e" :foreground "#fff"))))
     (header-line ((t (:background "#556" :foreground "#fff" :weight normal :height 1.125))))

     ;; Parenthesis matching
     (show-paren-match-face ((t (:background "#335566" :foreground nil))))
     (show-paren-mismatch-face ((t (:foreground "#f4f4ff" :background "#c73c3f"))))
     ;; Line highlighting
     (highlight ((t (:inverse-video t :background nil))))
     (hl-line ((t (:inverse-video nil :background "#333"))))
     
     (linum ((t (:background "#141414" :foreground "#555"))))

     ;; Calendar
     (holiday-face ((t (:foreground "#f43841"))))

     ;; Info
     (info-xref ((t (:foreground "#96a6c8"))))
     (info-visited ((t (:foreground "#9e95c7"))))

     ;; AUCTeX
     (font-latex-sectioning-5-face ((t (:foreground "#96a6c8" :bold t))))
     (font-latex-bold-face ((t (:foreground "#95a99f" :bold t))))
     (font-latex-italic-face ((t (:foreground "#95a99f" :italic t))))
     (font-latex-math-face ((t (:foreground "#73c936"))))
     (font-latex-string-face ((t (:foreground "#73c936"))))
     (font-latex-warning-face ((t (:foreground "#f43841"))))
     (font-latex-slide-title-face ((t (:foreground "#96a6c8"))))


     ;; semantic
     (semantic-tag-boundary-face ((t (:overline "#555555"))))
     (semantic-decoration-on-unparsed-includes ((t (:background "#554400"))))

     ;;misc
     (which-func ((t (:foreground "#ffdd33"))))

     ;;anything
     (anything-ff-file ((t (:foreground "#ddf" :background nil :underline nil))))
     (anything-ff-directory ((t (:foreground "#dfd" :background nil :underline nil))))
     

     ;; ;; ediff
     ;; ;; (ediff-current-diff-A ((t (:background ediff-even :foreground nil))))
     ;; ;; (ediff-current-diff-Ancestor ((t (:background ediff-even :foreground nil))))
     ;; ;; (ediff-current-diff-B ((t (:background ediff-even :foreground nil))))
     ;; ;; (ediff-current-diff-C ((t (:background ediff-even :foreground nil))))
     ;; (ediff-even-diff-A ((t (:background ,ediff-even :foreground nil))))
     ;; (ediff-even-diff-Ancestor ((t (:background ,ediff-even :foreground nil))))
     ;; (ediff-even-diff-B ((t (:background ,ediff-even :foreground nil))))
     ;; (ediff-even-diff-C ((t (:background ,ediff-even :foreground nil))))
     ;; ;; (ediff-fine-diff-A ((t (:background ediff-even :foreground nil))))
     ;; ;; (ediff-fine-diff-Ancestor ((t (:background ediff-even :foreground nil))))
     ;; ;; (ediff-fine-diff-B ((t (:background ediff-even :foreground nil))))
     ;; ;; (ediff-fine-diff-C ((t (:background ediff-even :foreground nil))))
     ;; (ediff-odd-diff-A ((t (:background ,ediff-odd :foreground nil))))
     ;; (ediff-odd-diff-Ancestor ((t (:background ,ediff-odd :foreground nil))))
     ;; (ediff-odd-diff-B ((t (:background ,ediff-odd :foreground nil))))
     ;; (ediff-odd-diff-C ((t (:background ,ediff-odd :foreground nil))))
     )))

(provide 'color-theme-hrehf-dark)