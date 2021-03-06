(require 'auto-complete-yasnippet)
(require 'auto-complete-emacs-lisp)
(require 'auto-complete-flex)
(require 'auto-complete-sql)
(require 'auto-complete-js)
(require 'auto-complete-pysmell)

;; SOLO SI ESTA ACTIVO CEDET
;; (require 'auto-complete-semantic)
(require 'auto-complete-css)
(global-auto-complete-mode t)
(set-face-background 'ac-menu-face "lightgray")
(set-face-underline 'ac-menu-face "darkgray")
(set-face-background 'ac-selection-face "steelblue")
(define-key ac-complete-mode-map "\t" 'ac-expand)
(define-key ac-complete-mode-map "\r" 'ac-complete)
(define-key ac-complete-mode-map "\M-n" 'ac-next)
(define-key ac-complete-mode-map "\M-p" 'ac-previous)
;; esto es para definir con cuantas letras se puede empezar a escribir
(setq ac-auto-start 1)
(setq ac-dwim t)
(set-default 'ac-sources '(ac-source-yasnippet ac-source-abbrev ac-source-words-in-buffer))
(setq ac-modes
      (append ac-modes
              '(eshell-mode
                sql-mode
                                        ;org-mode
                )))
                                        ;(add-to-list 'ac-trigger-commands 'org-self-insert-command)
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq ac-sources '(ac-source-yasnippet ac-source-abbrev ac-source-words-in-buffer ac-source-symbols))
            (eldoc-mode)              ;para que se parezca a slime
            ))
 
;; DEFINIR LOS NUEVOS SOURCES PARA EL AUTOCOMPLETE AQUI!!!
(add-hook 'nxml-mode-hook
          (lambda ()
            (setq ac-sources '(ac-source-flex ac-source-yasnippet ac-source-words-in-buffer ))
            (setq ac-omni-completion-sources '(("\\mx:\\=" ac-source-flex)))
            ))
 
(add-hook 'eshell-mode-hook
          (lambda ()
            (setq ac-sources '(ac-source-yasnippet ac-source-abbrev ac-source-files-in-current-dir ac-source-words-in-buffer))))
 
;; HACER YASNIPPETS PARA SQL
(add-hook 'sql-mode-hook
          (lambda ()
            (setq ac-sources '(ac-source-sql ac-source-words-in-buffer))))
 
(add-hook 'c++-mode-hook
          (lambda ()
            ;; (setq ac-sources '(ac-source-semantic ac-source-words-in-buffer))
            (setq ac-sources '(ac-source-yasnippet ac-source-abbrev ac-source-words-in-buffer))
            ;; (setq ac-omni-completion-sources '(("\\.\\=" ac-source-semantic)))
	    ;; (setq ac-omni-completion-sources '(("\\->\\=" ac-source-semantic)))
            ))

;; (add-hook 'java-mode-hook
;;           (lambda ()
;;             (setq ac-sources '(ac-source-yasnippet ac-source-words-in-buffer))
;;             (setq ac-omni-completion-sources '(("\\.\\=" ac-source-semantic)))
;;             ))

(add-hook 'css-mode-hook
          (lambda ()
            (setq ac-sources '(ac-source-css-keywords ac-source-yasnippet ac-source-words-in-buffer ))
            ))


(add-hook 'ruby-mode-hook
	  (lambda ()
	    (setq ac-omni-completion-sources '(
					       ("\\.\\=" ac-source-rcodetools)
					       ))
	    ))

(add-hook 'python-mode-hook
          '(lambda ()             
	     (setq ac-sources '(ac-source-yasnippet ac-source-words-in-buffer ))
             ;; (set (make-local-variable 'ac-sources) (append ac-sources '(ac-source-pysmell)))
	     ))

;; ESTA SERA UNA REFERENCIA CON AUTO-COMPLETE PARA JAVASCRIPT
;; (require 'auto-complete-js)
(add-hook 'js2-mode-hook
          (lambda ()
            (setq ac-sources '(ac-source-yasnippet 
			       ac-source-words-in-buffer ))
	    (require 'auto-complete-js-hooks)
	    ;; (setq ac-omni-completion-sources '(
	    ;; 				       ("\\window.\\=" ac-source-js-window)
	    ;; 				       ))
	    
	    ))
