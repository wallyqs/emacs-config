;;; Almost Space Cadet: color-theme-space-cadet.el

;; Author: Waldemar Quevedo <waldemar.quevedo@gmail.com>
;;
;; Based on the Space Cadet theme in Sublime Text
                                        ; Color theme support is required.
(require 'color-theme)

                                        ; Code start.
(defun color-theme-space-cadet ()
  (interactive)
  ;; (color-theme-reset-faces)
  (color-theme-install
   '(color-theme-almost-monokai
     ((background-color . "gray9")
      (foreground-color . "#dde6cf")
      (cursor-color . "#7f005d"))
     (default ((t (nil))))
     (bold ((t (:bold t))))
     (bold-italic ((t (:italic t :bold t))))
     (highlight-current-line-face ((t (:background "#0c0c0c"))))
     ;; (mode-line-inactive ((t (:background "#E0E0E0" :foreground "black" :box (:line-width 1 :style released-button)))))
     ;; (mode-line ((t (:background "#CD5907" :foreground "white" :box (:line-width 1 :style released-button)))))
     (font-lock-builtin-face ((t (:foreground "#8a4b66"))))
     (font-lock-comment-face ((t (:italic t :foreground "#777777"))))
     (font-lock-constant-face ((t (:foreground "#a8885a"))))
     (font-lock-doc-string-face ((t (:foreground "#473c45"))))
     (font-lock-string-face ((t (:foreground "#805978"))))
     (font-lock-function-name-face ((t (:foreground "#6078bf" :italic t))))
     (font-lock-keyword-face ((t (:foreground "#9ebf60"))))
     (font-lock-type-face ((t (:underline t :foreground "#8a4b66"))))
     (font-lock-variable-name-face ((t (:foreground "#A6E22A"))))
     (font-lock-warning-face ((t (:bold t :foreground "#FD5FF1"))))
     (highlight-80+ ((t (:background "#D62E00"))))
     (hl-line ((t (:background "#1A1A1A"))))
     (textile-link-face ((t (:foreground "#8EC65F"))))
     (textile-ol-bullet-face ((t (:foreground "#FC803A"))))
     (textile-ul-bullet-face ((t (:foreground "#FC803A"))))
     (region ((t (:foreground "cyan" :background "dark cyan"))))
     ;; (region ((t (:foreground "cyan" :background "#6DC5F1"))))
     (ido-subdir ((t (:foreground "#F1266F"))))
     (primary-selection ((t (:background "#3B3B3F"))))
     (isearch ((t (:background "#555555"))))
     (zmacs-region ((t (:background "#555577"))))
     (secondary-selection ((t (:background "#545459"))))
     )
   )
  )
(provide 'color-theme-space-cadet)
                                        ;---------------
                                        ; Code end.
