;; emacs-elpa.el - loading and configuring the emacs list package archive

;; Here is the package kit, what you install with it is up to you, there
;; will probably be some overlap though in what I provide in the modes
;; directory and what the elpa offers, not sure what to do about that
;; i will not including anything in the elpa directory, it's simply there
;; for you to install to.
;;
;; I'm not totally comfortable with how i am doing this, but it seems the
;; best solution till another presents itself.
;;
;; Why?  Well, the ELPA is very convenient
(load-lib "package")
(load-lib-dir "elpa")
(require 'package)
(setq package-user-dir (concat root-dir "elpa"))
(package-initialize)