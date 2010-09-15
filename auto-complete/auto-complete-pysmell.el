(require 'auto-complete)

(defvar ac-source-pysmell
  '((candidates
     . (lambda ()
         (require 'pysmell)
         (pysmell-get-all-completions))))
  "Source for PySmell")

(provide 'auto-complete-pysmell)
