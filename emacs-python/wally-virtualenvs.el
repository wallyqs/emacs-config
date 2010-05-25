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
    (insert "source python-environments/gsoc/bin/activate")
    )
  )

