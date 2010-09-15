;; (require 'python-mode)
;; (require 'ipython)
;; (setq py-python-command-args '( "-colors" "Linux"))
;; (defadvice py-execute-buffer (around python-keep-focus activate)
;;   "return focus to python code buffer"
;;   (save-excursion ad-do-it))
;;(require 'pymacs)
;;(pymacs-load "ropemacs" "rope-")
;; (require 'pysmell)
(add-hook 'python-mode-hook (lambda () 
			      ;; (pysmell-mode 1)
			      (auto-complete-mode t)
			      ))
;; (require 'django)

;; django mode
(require 'django-mode)
(require 'django-html-mode)
(require 'django-utils)

(provide 'wallemacs-python)
