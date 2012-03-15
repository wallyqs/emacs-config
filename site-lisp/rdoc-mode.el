(defface rdoc-headers-1
  '((t (:inherit variable-pitch :foreground "white"
		  :weight bold :height 1.4)))
  "rdoc mode headers level 1")

(defface rdoc-headers-2
  '((t (:inherit variable-pitch :foreground "#cafe12" :weight bold :height 1.3)))
  "rdoc mode headers level 2")

(defface rdoc-headers-3
  '((t (:inherit variable-pitch :foreground "#5A7644" :weight bold :height 1.2)))
  "rdoc mode headers level 3")

(defface rdoc-headers-4
  '((t (:inherit variable-pitch :foreground "#F1266F" :weight bold)))
  "rdoc mode headers level 4")

(define-generic-mode 'rdoc-mode
  ()					;comment-list
  '()					;keyword-list
  '(					;font-lock-list
    ("^=[^=].*" . 'rdoc-headers-1)
    ("^==[^=].*" . 'rdoc-headers-2)
    ("^===[^=].*" . 'rdoc-headers-3)
    ("^====[^=].*" . 'rdoc-headers-4)
    ("^[\\*#]\\{1,9\\} " . 'bold)
    ("\\(?:[^a-zA-Z0-9]\\)?\\*[^*]+\\*\\(?:[^a-zA-Z0-9]\\)" . 'bold)
    ("\\(?:[^a-zA-Z0-9]\\)?\\_[^_]+\\_\\(?:[^a-zA-Z0-9]\\)" . 'italic)
    )
  '("README_FOR_APP" "\\.rdoc$")	;auto-mode-list
  '((lambda () (auto-fill-mode t)))	;function-list
  "Major mode for editing RDOC files.")

(provide 'rdoc-mode)