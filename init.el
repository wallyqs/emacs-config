;; LOADPATHS
(defvar *wallemacs-root* 
  (file-name-directory 
   (or (buffer-file-name) load-file-name)))

(add-to-list 'load-path (concat *wallemacs-root* "config/"))
(add-to-list 'load-path (concat *wallemacs-root* "site-lisp/"))
(add-to-list 'load-path (concat *wallemacs-root* "color-themes/"))
(add-to-list 'load-path (concat *wallemacs-root* "auto-complete/"))
(add-to-list 'load-path (concat *wallemacs-root* "emacs-python/"))
(add-to-list 'load-path (concat *wallemacs-root* "emacs-rails/"))
(add-to-list 'load-path (concat *wallemacs-root* "modules/"))
(add-to-list 'load-path (concat *wallemacs-root* "modules/anthy"))
(add-to-list 'load-path (concat *wallemacs-root* "modules/mumamos"))
(add-to-list 'load-path (concat *wallemacs-root* "modules/twittering-mode1"))
(add-to-list 'load-path (concat *wallemacs-root* "modules/org-mode/lisp"))
(add-to-list 'load-path (concat *wallemacs-root* "modules/org-mode/contrib"))
(add-to-list 'load-path (concat *wallemacs-root* "modules/jdee"))
(add-to-list 'load-path (concat *wallemacs-root* "emacs-python/Pymacs/"))
(add-to-list 'load-path (concat *wallemacs-root* "emacs-python/ropemacs/"))
(add-to-list 'load-path (concat *wallemacs-root* "emacs-python/django-mode/"))
(add-to-list 'load-path (concat *wallemacs-root* "yasnippet/"))

;; Add sensible defaults
(require 'wallemacs-defaults)

;; Add snippets
(require 'yasnippet)
(yas/initialize)
(yas/load-directory (concat *wallemacs-root* "yasnippet/snippets"))
(yas/load-directory (concat *wallemacs-root* "yasnippet/django-snippets"))
(yas/load-directory (concat *wallemacs-root* "yasnippet/flex-snippets"))
(yas/load-directory (concat *wallemacs-root* "yasnippet/rails-snippets"))

;; Add auto-complete
(require 'auto-complete)
(when (require 'auto-complete nil t)
  (load-file (concat *wallemacs-root* "auto-complete/auto-complete-config.el"))
  )                                     ;fin del autocomplete

;; Add emacs-rails
(require 'wallemacs-rails)

;; Add emacs-python
(require 'wallemacs-python)

;; Set up color-theme
(require 'color-theme)
(color-theme-initialize)

;; Set my keybindings
(require 'wallemacs-keybindings)

(require 'wallemacs-local)
