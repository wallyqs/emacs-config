(add-to-list 'load-path "~/wallemacs/emacs-rails-reloaded1/")
(require 'rails-autoload)
(require 'rhtml-mode)
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

(provide 'wallemacs-rails)
