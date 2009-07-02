(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(browse-url-browser-function (quote browse-url-default-browser))
 '(desktop-base-file-name ".emacs.desktop")
 '(desktop-base-lock-name ".emacs.desktop.lock")
 '(ecb-options-version "2.32")
 '(initial-buffer-choice t)
 '(mumamo-background-chunk-major (quote mumamo-background-chunk-major))
 '(mumamo-chunk-coloring (quote no-chunks-colored))
 '(nxhtml-skip-welcome t)
 '(rails-ws:default-server-type "mongrel")
 '(speedbar-show-unknown-files t)
 '(tramp-default-host "localhost")
 '(tramp-default-method "ssh")
 '(w3m-home-page "http://news.ycombinator.com"))

;; CARGAR EL PATH DEL SITE LISP
(add-to-list 'load-path "~/wallemacs/site-lisp")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/")

;; lo del js2, quiero poner el auto-complete tambien...
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; IMPORTANTISIMO PONER AL RUBY PRIMERO
(autoload 'ruby-mode "ruby-mode" "Major mode for ruby files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))
(require 'ruby-electric)
(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
	  '(lambda ()
	     (inf-ruby-keys)
	     (ruby-electric-mode t)
	     ))
;;;;;;;;;;;;;;;;;;;ALGUNOS BINDINGS LOCOS;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key (kbd "<C-tab>") 'dabbrev-expand)
(global-set-key "\C-c\C-p" 'sgml-tag) 
(global-set-key "\C-c\C-o" 'shrink-window)
(global-set-key "\C-c\C-k" 'copy-region-as-kill)
(global-set-key "\C-c\C-v" 'x-clipboard-yank)

;; hacer que no se atore con esto cuando no estoy en window mode
(scroll-bar-mode nil)
(tool-bar-mode nil)
(show-paren-mode t)
(ido-mode t)
(menu-bar-mode nil)

(put 'upcase-region 'disabled nil)

;;;;;;;;;;;;;;;;;;;;;DE NUEVO ALGO PARA LAS FONTS;;;;;;;;;;;;;;;;;;;;;;;
(set-default-font "-unknown-inconsolata-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")

;;;;COLOR THEMES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/wallemacs/emacs-rails-kit/vendor/color-theme")
(require 'color-theme)
(color-theme-initialize)
(load-file "~/wallemacs/site-lisp/color-theme-merbivore.el")
(load-file "~/wallemacs/site-lisp/color-theme-tango-2.el")
(load-file "~/wallemacs/site-lisp/color-theme-vibrant-ink.el")
(load-file "~/wallemacs/site-lisp/color-theme-wunki.el")
(load-file "~/wallemacs/site-lisp/color-theme-nightingale.el")
(load-file "~/wallemacs/site-lisp/color-theme-blue.el")
;; (load-file "~/wallemacs/site-lisp/color-theme-zenburn.el")

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Soporte para el GIT y SVN;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'git)
(require 'psvn)

(add-to-list 'load-path "~/wallemacs/git-emacs1")
(add-to-list 'load-path "~/wallemacs/magit")
(require 'git-emacs)
(require 'magit)


;; DEDICATED KEYS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key [?\C--] 'hippie-expand)
(global-set-key (kbd "<f1>") 'copy-region-as-kill)
(global-set-key (kbd "<f2>") 'ido-switch-buffer)
(global-set-key (kbd "<f3>") 'find-file-other-window)
(global-set-key (kbd "<S-f3>") 'find-file-other-frame)
(global-set-key (kbd "<f4>") 'speedbar)
(global-set-key (kbd "<f5>") 'replace-regexp)
(global-set-key (kbd "<f6>") 'replace-string)
(global-set-key (kbd "<f7>") 'regexp-builder)
(global-set-key (kbd "<f8>") 'toggle-truncate-lines)
(global-set-key (kbd "<C-f9>") 'menu-bar-mode)
(global-set-key (kbd "<f10>") 'linum-mode)
(global-set-key (kbd "<f11>") 'make-frame-command)
;; (global-set-key (kbd "<f12>") 'anthy-mode)
;; esto es para llamar las funciones de ruby automaticamente, necesita las rcodetools
;; (global-set-key (kbd "<C-f12>") 'xmp)

;; COSAS PARA EL TWIT MODE
(load-file "~/wallemacs/site-lisp/twit.el")
(twit-minor-mode)

;; aqui le voy a poner lo del twitter.el
(autoload 'twitter-get-friends-timeline "twitter" nil t)
(autoload 'twitter-status-edit "twitter" nil t)
(add-hook 'twitter-status-edit-mode-hook 'longlines-mode)

;; GLOBAL SET KEYS DE LOS SHIFTS
(global-set-key (kbd "<S-f1>")  'twitter-get-friends-timeline)
(global-set-key (kbd "<S-f2>")  'ido-switch-buffer-other-window)
(global-set-key (kbd "<S-f4>")  'speedbar-update-contents)
(global-set-key (kbd "<S-f8>")  'rails/console)
(global-set-key (kbd "<C-f11>")  'undo)
(global-set-key (kbd "<C-S-f2>")  'ido-switch-buffer-other-frame)
(global-set-key (kbd "<S-f11>")  'text-scale-decrease)
(global-set-key (kbd "<S-f12>")  'text-scale-increase)
(global-set-key (kbd "<M-f12>")  'other-frame)

;; para poder moverme en las ventanas
(windmove-default-keybindings 'meta)

;; ;; para el jabber.el 
;; (add-to-list 'load-path "~/wallemacs/site-lisp/emacs-jabber/")
;; (load "jabber-autoloads")
;; (require 'jabber)
;; (setq jabber-account-list '(
;;                             ("invertedplate@gmail.com"
;; ;;; 			     (:password . nil) or (:password . "")
;; 			     (:network-server . "talk.google.com")
;; ;;; 			     (:port . 443)
;; 			     (:port . 5223)
;; 			     (:connection-type . ssl))
;;                             ))

;; ;; el winner mode es para lo de C-c y left etc..
(winner-mode t)

(add-to-list 'load-path "~/wallemacs/emacs-rails-reloaded1/")
(require 'rails-autoload)

;; ESTOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
(add-to-list 'load-path "~/wallemacs/yasnippets-rails")
(add-to-list 'load-path "~/wallemacs/yasnippet/")
;; (add-hook 'ruby-mode-hook ; or rails-minor-mode-hook ?
;;           '(lambda ()
;;              (make-variable-buffer-local 'yas/trigger-key)
;;              ;; (setq yas/trigger-key [tab])
;; 	     ))

(require 'yasnippet)
(add-to-list 'yas/extra-mode-hooks
             'ruby-mode-hook)
(yas/initialize)
(setq yas/window-system-popup-function 'yas/x-popup-menu-for-template)
(yas/load-directory "~/wallemacs/yasnippet/snippets")
(yas/load-directory "~/wallemacs/yasnippets-rails/rails-snippets/")
(make-variable-buffer-local 'yas/trigger-key)
(require 'rhtml-mode)

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(require 'weblogger)

;; ;; super anything
(add-to-list 'load-path "~/wallemacs/site-lisp/auto-complete/")

(require 'auto-complete)
;; (global-auto-complete-mode t)
 (when (require 'auto-complete nil t)
   (require 'auto-complete-yasnippet)
   ;; (require 'auto-complete-ruby)
   (require 'auto-complete-emacs-lisp)
   (require 'auto-complete-css)
   (global-auto-complete-mode t)
   (set-face-background 'ac-menu-face "lightgray")
   (set-face-underline 'ac-menu-face "darkgray")
   (set-face-background 'ac-selection-face "steelblue")
   (define-key ac-complete-mode-map "\t" 'ac-expand)
   (define-key ac-complete-mode-map "\r" 'ac-complete)
   (define-key ac-complete-mode-map "\M-n" 'ac-next)
   (define-key ac-complete-mode-map "\M-p" 'ac-previous)
   (setq ac-auto-start 3)
   (setq ac-dwim t)
   (set-default 'ac-sources '(ac-source-yasnippet ac-source-abbrev ac-source-words-in-buffer))
   (setq ac-modes
         (append ac-modes
                 '(eshell-mode
                   ;org-mode
                   )))
   ;(add-to-list 'ac-trigger-commands 'org-self-insert-command)
   (add-hook 'emacs-lisp-mode-hook
             (lambda ()
               (setq ac-sources '(ac-source-yasnippet ac-source-abbrev ac-source-words-in-buffer ac-source-symbols))))
   (add-hook 'eshell-mode-hook
             (lambda ()
               (setq ac-sources '(ac-source-yasnippet ac-source-abbrev ac-source-files-in-current-dir ac-source-words-in-buffer))))
   ;; (add-hook 'ruby-mode-hook
   ;;              (lambda ()
   ;;                (setq ac-omni-completion-sources '(("\\.\\=" ac-source-rcodetools)))))
)					;fin del autocomplete


(defun hashRocket()  (interactive)  (insert " => "))
(defun heart()  (interactive)  (insert "♥"))

(load-file "~/wallemacs/site-lisp/typing.el")

;; para comentar una linea como en el Aptana
(fset 'wally-comment-macro
   [?\C-a ?\C-  ?\C-e ?\M-\; ?\C-a ?\C-n])
(global-set-key "\C-c\C-a" 'wally-comment-macro)
(global-set-key "\C-c=" 'hashRocket)

(fset 'wally-select-line-macro
   [?\C-a ?\C-  ?\C-e])
(global-set-key "\C-c\C-e" 'wally-select-line-macro)

