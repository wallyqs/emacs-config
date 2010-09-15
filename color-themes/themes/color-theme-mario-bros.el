;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

(defun color-theme-mario-bros ()
  (interactive)
  (color-theme-install
   '(color-theme-mario-bros
;;      ((background-color . "#57432e")
;;      ((background-color . "#46332e")
      ((background-color . "gray12")
      (background-mode . light)
      (border-color . "#541818")
      (cursor-color . "#94e449")
      (foreground-color . "#ffffff")
      (mouse-color . "black"))
     (fringe ((t (:background "#541818"))))
     (mode-line ((t (:foreground "#000000" :background "#dc4747"))))
     (region ((t (:background "#68006b"))))
     (font-lock-builtin-face ((t (:foreground "#c02a2a"))))
;;     (font-lock-comment-face ((t (:foreground "#451A28"))))
     (font-lock-comment-face ((t (:foreground "#9F2F28"))))
     (font-lock-function-name-face ((t (:foreground "#d88fdc"))))
     (font-lock-keyword-face ((t (:foreground "#e19898"))))
     (font-lock-string-face ((t (:foreground "#73d37a"))))
     (font-lock-type-face ((t (:foreground"#dfb03a"))))
     (font-lock-variable-name-face ((t (:foreground "#ff6666"))))
     (minibuffer-prompt ((t (:foreground "#7299ff" :bold t))))
     (font-lock-warning-face ((t (:foreground "#111111" :bold t))))
     )))
(provide 'color-theme-mario-bros)