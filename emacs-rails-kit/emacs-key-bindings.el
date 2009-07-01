;; emacs-key-bindings.el - bindings that make life easier

(global-set-key (kbd "C-c b") 'eval-buffer)
(global-set-key (kbd "C-x f") 'recentf-ido-find-file)
(global-set-key (kbd "M-s") 'save-buffer)
(global-set-key (kbd "M-z") 'undo)

;; set line commenting to textmate style
(global-set-key (kbd "M-/") 'comment-or-uncomment-region)

;; above commenting binding took over this useful function
(global-set-key (kbd "M-d") 'dabbrev-expand)

