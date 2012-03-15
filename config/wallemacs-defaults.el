(custom-set-variables
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
(custom-set-faces
 '(mumamo-background-chunk-major ((((class color) (min-colors 88) (background dark)) nil)))
 '(twitter-header-face ((t nil)))
 '(mumamo-background-chunk-submode ((((class color) (min-colors 88) (background dark)) nil))))

(defun wally-insert-backslash()
  "Japanese Mac does not have backslash button"
  (interactive)
  (insert "\\")
  (message "You are in Japan!"))


(defun wally-alpha()
  (interactive)
  (set-frame-parameter (selected-frame) 'alpha
                       (string-to-int (read-from-minibuffer "How alpha? (0 - 100): " ))))
(defun wally-fix-font()
  (interactive)
  (set-default-font "-unknown-VL Gothic-normal-normal-normal-*-13-*-*-*-*-0-iso10646-1")
  ;; (set-default-font "-unknown-VL Gothic-normal-normal-normal-*-14-*-*-*-*-0-iso10646-1")
  )

(defun wally-fix-font1()
  (interactive)
  ;; (set-default-font "-unknown-VL Gothic-normal-normal-normal-*-13-*-*-*-*-0-iso10646-1")
  (set-default-font "-unknown-VL Gothic-normal-normal-normal-*-14-*-*-*-*-0-iso10646-1")
  )

(defun wally-fix-font-bitstream()
  (interactive)
  (set-default-font "-bitstream-Bitstream Vera Sans Mono-bold-normal-normal-*-14-*-*-*-m-0-iso10646-1")
  )

(defun wally-fix-font-inconsolata()
  (interactive)
  (set-default-font "-unknown-Inconsolata-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")
  )

(defun wally-fix-font-envy()
  (interactive)
  (set-default-font "-unknown-Envy Code R-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1")
  )



;; PRETTY-LAMBDAS
(defun pretty-lambdas ()
  (interactive)
  (font-lock-add-keywords
   nil `(("(?\\(lambda\\>\\)"
          (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                    ,(make-char 'greek-iso8859-7 107))
                    nil))))))

(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer."
  (interactive)
  (indent-whole-buffer)
  (untabify-buffer)
  (delete-trailing-whitespace))

(defun lorem ()
  "Insert a lorem ipsum."
  (interactive)
  (insert "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do "
          "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim"
          "ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut "
          "aliquip ex ea commodo consequat. Duis aute irure dolor in "
          "reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla "
          "pariatur. Excepteur sint occaecat cupidatat non proident, sunt in "
          "culpa qui officia deserunt mollit anim id est laborum."))

(defun wally-load-java ()
  "Load cedet and jdee"
  (interactive)
  ;; jdee ::::::::::::::::::::::::::::::::::::::::::::
  (add-to-list 'load-path "~/wallemacs/jdee/lisp")
  (load "jde")
  (load-file "~/wallemacs/jdee/lisp/jde.el")
  ;; (setq jde-web-browser "BROWSER")
  ;; (setq jde-doc-dir "JDK DIRECTORY")
  ;; (jde-db-set-source-paths "~/proyectos/java_threads")
  )

(defun indent-whole-buffer()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

(fset 'wally-comment-indent-line
      [home ?\C-  ?\S-\C-e ?\M-\; ?\S-\C-a tab home])

(fset 'choche-start-mysql
      [?\M-x ?s ?q ?l ?- ?m ?s ?q backspace backspace ?y ?s ?q ?l return ?r ?o ?o ?t return ?i ?n ?o ?v ?a ?z ?0 ?8 return return ?l ?o ?c ?a ?l ?h ?o ?s ?t return])

(defun filetemignon()
  (interactive)
  (message "Filete mignon listo!!!"))

(defun swap-windows ()
  "If you have 2 windows, it swaps them."
  (interactive)
  (cond ((not (= (count-windows) 2)) (message "You need exactly 2 windows to do this."))
        (t
         (let* ((w1 (first (window-list)))
                (w2 (second (window-list)))
                (b1 (window-buffer w1))
                (b2 (window-buffer w2))
                (s1 (window-start w1))
                (s2 (window-start w2)))
           (set-window-buffer w1 b2)
           (set-window-buffer w2 b1)
           (set-window-start w1 s2)
           (set-window-start w2 s1)))))

(defun view-url ()
  "Open a new buffer containing the contents of URL."
  (interactive)
  (let* ((default (thing-at-point-url-at-point))
         (url (read-from-minibuffer "URL: " default)))
    (switch-to-buffer (url-retrieve-synchronously url))
    (rename-buffer url t)
    ;; TODO: switch to nxml/nxhtml mode
    (cond ((search-forward "<?xml" nil t) (xml-mode))
          ((search-forward "<html" nil t) (html-mode)))))

(defun fullscreen (&optional f)
  (interactive)
  (set-frame-parameter f 'fullscreen
                       (if (frame-parameter f 'fullscreen) nil 'fullboth)))

;; (require 'blank-mode)
;; (load-file "~/wallemacs/site-lisp/light-symbol.el")
(require 'paredit)
(require 'textmate)
(require 'pastie)
(require 'magit)
(require 'hacker-news)
(require 'tabbar)
(require 'sr-speedbar)
(require 'dame-shell)
(require 'textile-mode)
(require 'uniquify)
(require 'php-mode)
(require 'twittering-mode)
(require 'rainbow-mode)
(require 'haml-mode)
(require 'sass-mode)

;; (require 'ourcomments-util)
;; (require 'mlinks)
;; (require 'mumamo-fun)

(add-to-list 'auto-mode-alist '("\\.rdoc$" . rdoc-mode))
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
;; (setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-buffer-name-style 'post-forward uniquify-separator ":")
(add-to-list 'auto-mode-alist '("\\.textile$" . textile-mode))

(require 'rails-autoload)
(require 'rhtml-mode)
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;; Ruby mode
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

;; rhtml-templates
(add-to-list 'auto-mode-alist '("\\.rhtml$" . rhtml-mode))
(add-to-list 'auto-mode-alist '("\\.haml$" . haml-mode))

;; For editing Cascadenik Styles
(add-to-list 'auto-mode-alist '("\\.mml$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.mss$" . css-mode))

(require 'wallemacs-javascript)

(set-frame-parameter (selected-frame) 'alpha 98)
;; (scroll-bar-mode)
;; (tool-bar-mode)
(setq scroll-margin 0 scroll-conservatively 100000 scroll-preserve-screen-position 1)
(display-time)
(show-paren-mode t)
(ido-mode t)
(menu-bar-mode nil)
(put 'upcase-region 'disabled nil)
(speedbar-disable-update)
(winner-mode t)
(setq delete-auto-save-files t)

;; Objc-mode as major mode for Objective j
;; (add-to-list 'auto-mode-alist '("\\.j$" . objc-mode))
(require 'objj-mode)

(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)

;; set up path on OS x
(when (equal system-type 'darwin)
  (setenv "PATH" (concat "/opt/local/bin:/usr/local/bin:" (getenv "PATH")))
  (push "/opt/local/bin" exec-path))

;; 
;; fixing the js2-mode, taken from https://github.com/mitchellh/dotfiles/blob/master/emacs.d/modes.el
(require 'espresso)

;; js-mode (espresso)
;; Espresso mode has sane indenting so we use that.
(setq js-indent-level 2)

;; Customize JS2
(setq js2-basic-offset 2)
(setq js2-cleanup-whitespace t)

;; Custom indentation function since JS2 indenting is terrible.
;; Uses js-mode's (espresso-mode) indentation semantics.
;;
;; Based on: http://mihai.bazon.net/projects/editing-javascript-with-emacs-js2-mode
;; (Thanks!)
(defun my-js2-indent-function ()
  (interactive)
  (save-restriction
    (widen)
    (let* ((inhibit-point-motion-hooks t)
           (parse-status (save-excursion (syntax-ppss (point-at-bol))))
           (offset (- (current-column) (current-indentation)))
           (indentation (js--proper-indentation parse-status))
           node)

      (save-excursion

        ;; I like to indent case and labels to half of the tab width
        (back-to-indentation)
        (if (looking-at "case\\s-")
            (setq indentation (+ indentation (/ js-indent-level 2))))

        ;; consecutive declarations in a var statement are nice if
        ;; properly aligned, i.e:
        ;;
        ;; var foo = "bar",
        ;;     bar = "foo";
        (setq node (js2-node-at-point))
        (when (and node
                   (= js2-NAME (js2-node-type node))
                   (= js2-VAR (js2-node-type (js2-node-parent node))))
          (setq indentation (+ 4 indentation))))

      (indent-line-to indentation)
      (when (> offset 0) (forward-char offset)))))

(defun my-js2-mode-hook ()
  (if (not (boundp 'js--proper-indentation))
      (progn (js-mode)
             (remove-hook 'js2-mode-hook 'my-js2-mode-hook)
             (js2-mode)
             (add-hook 'js2-mode-hook 'my-js2-mode-hook)))
  (set (make-local-variable 'indent-line-function) 'my-js2-indent-function)
  (define-key js2-mode-map [(return)] 'newline-and-indent)
  (define-key js2-mode-map [(backspace)] 'c-electric-backspace)
  (define-key js2-mode-map [(control d)] 'c-electric-delete-forward)
  (message "JS2 mode hook ran."))

;; Add the hook so this is all loaded when JS2-mode is loaded
(add-hook 'js2-mode-hook 'my-js2-mode-hook)

;; Adding configuration for org2blog
(require 'org2blog)

;; (setq org2blog-blog-alist
;;        '(("wordpress"
;;           :url "http://username.wordpress.com/xmlrpc.php"
;;           :username "username"   
;;           :default-title "Hello World"
;;           :default-categories ("org2blog" "emacs")
;;           :tags-as-categories nil)
;;          ("my-blog"             
;;           :url "http://username.server.com/xmlrpc.php"
;;           :username "admin")))


(add-hook 'org-mode-hook
	  (lambda ()
	    (local-set-key "\C-cp" 'org-insert-property-drawer)
	    ))


(defun wally-reload-yasnippet()
  (interactive)
  (require 'yasnippet)
  (yas/initialize)
  (yas/load-directory (concat *wallemacs-root* "yasnippet/snippets"))
  (yas/load-directory (concat *wallemacs-root* "yasnippet/django-snippets"))
  (yas/load-directory (concat *wallemacs-root* "yasnippet/flex-snippets"))
  (yas/load-directory (concat *wallemacs-root* "yasnippet/rails-snippets")))


(defun wally-fix-buffer-settings()
  (interactive)
  (set-cursor-color "green")
  (set-foreground-color "white")
  (set-frame-parameter (selected-frame) 'alpha 95))

(add-to-list 'auto-mode-alist '("README$" . org-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))

(add-to-list 'auto-mode-alist '("\\.less$" . css-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . javascript-mode))
(add-to-list 'auto-mode-alist '("\\.ejs$" . rhtml-mode))

(defun wally-insert-org-block()
  (interactive)
  (insert "#+BEGIN_SRC \n#+END_SRC")
  (previous-line)
  (end-of-line))

(provide 'wallemacs-defaults)