(require 'comint)
(provide 'django-utils)
(defvar python-webserver-command "python manage.py runserver")
(defvar python-webserver-status "off")

;; Should sniff that it is a Django Resource like in Emacs Rails
(defun python-django-webserver()
  "Starts the Django webserver "
  (interactive)
  (if (string-equal python-webserver-status "off")
      (progn 
	(message "Django Development Server started on port 0.0.0.0:8000")
	(set-buffer (apply 'make-comint "PServer" "python" nil (list "manage.py" "runserver")))
	(setq python-webserver-status "on")
	)
    ;;else
    (progn
      (message "Server Stopped")
      (setq python-webserver-status "off")
      ;; deberia de mandar una senhal al buffer
      ;; (kill-buffer "*PServer*")
      (with-current-buffer "*PServer*"
	(comint-kill-subjob))
      ;; (comint-send-string "PServer" "")
      )
    )
  )

(defun python-django-syncdb()
  "Migrates the database "
  (interactive)
  (message "Synchronizing the database")
  (set-buffer (apply 'make-comint "POutput" "python" nil (list "manage.py" "syncdb")))
  )


(defun python-django-shell()
  "Migrates the database "
  (interactive)
  (message "Starting Django Development Shell")
  (set-buffer (apply 'make-comint "django" "python" nil (list "manage.py" "shell" "--plain")))
  (switch-to-buffer-other-window "*django*")
  )

(add-hook 'django-mode-hook
          (lambda ()
            (local-set-key "\C-c\M-w" 'python-django-webserver)
            (local-set-key "\C-c\M-d" 'python-django-syncdb)
            (local-set-key "\C-c\M-s" 'python-django-shell)
	    (auto-complete-mode)
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