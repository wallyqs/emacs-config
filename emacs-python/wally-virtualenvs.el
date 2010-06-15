(require 'comint)
(provide 'django-utils)


(defun wally-gsoc-python-env()
  (interactive)
  (shell)
  (rename-buffer "*GSoC Python Env*" t) ; unique
  (set-buffer "*GSoC Python Env*")
  ;; (switch-to-buffer-other-window "*GSoC Python Env*")
  ;; ahora debe de activar el env

  (with-current-buffer "*GSoC Python Env*"
    ;; (comint-kill-subjob))
    ;; (comint-send-string "GSoC Python Env" "source")
    (insert "source /home/mariko/python-environments/gsoc/bin/activate")
    )
  )

(defun wally-shell-gsoc-python-env()
  (interactive)
  ;; no se puede hacer esto...

  ;; (set-buffer (apply 'make-comint "GSoC Python Env Shell" "source" nil (list "/home/mariko/python-environments/gsoc/bin/activate ;" "python")))
  ;; (shell)
  ;; (rename-buffer "*GSoC Python Env*" t) ; unique
  ;; (set-buffer "*GSoC Python Env*")
  (switch-to-buffer-other-window "*GSoC Python Env*")
    
  )


(defun wally-postgres-gsoc-python-env ()
  (interactive)
  (insert "source /home/mariko/python-environments/gsoc/bin/activate")
  )

(defun wally-add-current-path-python ()
  (interactive)
  (insert "import sys; import os; sys.path.append(os.getcwd())")
  )