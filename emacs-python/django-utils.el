(require 'comint)
(provide 'django-utils)
(defvar python-webserver-command "python manage.py runserver")

;; Should sniff that it is a Django Resource like in Emacs Rails
(defun python-webserver()
  "Starts the Django webserver "
  (interactive)
  (message "Django Development Server started on port 0.0.0.0:8000")
  (set-buffer (apply 'make-comint "PServer" "python" nil (list "manage.py" "runserver")))
  )

(add-hook 'python-mode-hook
	  (lambda ()
	    (local-set-key "\C-c\M-w" 'python-webserver)
	    ;; (local-set-key "\C-c\C-cs" 'python-send-buffer)
	    )
	  )

;; (add-hook python-mode-hook

;; (defun python-webserver ()
;;   (interactive)
  
;;   (apply 'make-comint python-webserver-command python-webserver-command nil '())
;;   (delete-other-windows)
;;   (switch-to-buffer-other-window "*cmd*")
;;   (other-window -1)
;;   ;; (other-window -1)
;;   )

;; (defun python-webserver-string()
;;   (interactive)
;;   (comint-send-string (get-buffer-process "*cmd*") "oijiojiojjojioj")
;; )

;; FIRST TRY
;; Necesito que abra un buffer
;; que se llame *PServer* con la consola de python
;; (defun python-webserver (cmd &optional dont-switch-p)
;;   "Start python manage.py runserver"
;;   (interactive (list (if current-prefix-arg
;;                          (read-string "Run PServer: " python-webserver-command)
;;                        python-webserver-command) ;cmd
;;                      ))
;;   (if (not (comint-check-proc "*PServer*"))
;;       (save-excursion (let ((cmdlist (split-string cmd)))
;;                         (set-buffer (apply 'make-comint "python" (car cmdlist)
;;                                            nil (cdr cmdlist)))
;;                         (inferior-django-webserver-mode)
;;                         )
;;                       )
;;     )
;;   (setq inferior-js-program-command cmd)
;;   (setq inferior-js-buffer "*PServer*")
;;   ;; (if (not dont-switch-p)
;;   (pop-to-buffer "*PServer*")
;;   ;; )
;;   )

;; (define-derived-mode inferior-django-webserver-mode comint-mode "Django Webserver"
;;   "Buffer for the Django Server like in Emacs Rails"
;;   )