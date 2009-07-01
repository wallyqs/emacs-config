;; init.el - from which all other configuration flows

(require 'cl)
(require 'ansi-color)
(require 'recentf)

(defvar root-dir "~/.emacs.d/")
(defun load-lib (name)
  (load (concat root-dir name ".el")))
(defun load-lib-dir (path)
  (add-to-list 'load-path (concat root-dir path)))

(load-lib-dir root-dir)

(setq autoload-file (concat root-dir "loaddefs.el"))
(setq custom-file (concat root-dir "custom.el"))

(load-lib "emacs-defaults")
(load-lib "emacs-elpa")
(when window-system (load-lib "emacs-gui"))
(load-lib "emacs-key-bindings")
(load-lib "emacs-functions")
(load-lib "emacs-vendor")
(load-lib "emacs-rails")

(load custom-file 'noerror)

;; Load user config and system config
(setq system-specific-config (concat root-dir system-name ".el")
      user-specific-config (concat root-dir user-login-name ".el"))

(if (file-exists-p system-specific-config) (load system-specific-config))
(if (file-exists-p user-specific-config) (load user-specific-config))

 ;; init.el end