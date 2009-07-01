;; emacs-gui.el - configuration for when running emacs in a gui environment

;; interface tweaks
(tooltip-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

;; put buffer name in titlebar
(setq frame-title-format '(buffer-file-name "%f" ("%b")))

;; turn off 3d modeline
(set-face-attribute 'mode-line nil :box nil)

(column-number-mode t)

;; Full screen toggle 
(defun toggle-fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen (if (frame-parameter nil 'fullscreen)
                                           nil
                                         'fullboth)))
(global-set-key (kbd "M-n") 'toggle-fullscreen)

;; set emacs to dark mode
(defun dark-theme ()
  (interactive)
  (set-background-color "black")
  (set-foreground-color "white"))

(defun light-theme ()
  (interactive)
  (set-background-color "white")
  (set-foreground-color "black"))

(defun refresh-file ()
  (interactive)
  (revert-buffer t t t))

(global-set-key [f5] 'refresh-file)

;; color theme - with merbivore and vibrant ink themes included
(load-lib-dir "vendor/color-theme")
(load-lib-dir "vendor/color-theme-merbivore")
(load-lib-dir "vendor/color-theme-vibrant-ink")
(load-lib-dir "vendor/color-theme-tango-2")
(load-lib-dir "vendor/color-theme-wunki")
(require 'color-theme)
(color-theme-initialize)
(setq color-theme-is-global t)
(load-file (concat root-dir "/vendor/color-theme-merbivore/color-theme-merbivore.el"))
(load-file (concat root-dir "/vendor/color-theme-vibrant-ink/color-theme-vibrant-ink.el"))
(load-file (concat root-dir "/vendor/color-theme-tango-2/color-theme-tango-2.el"))
(load-file (concat root-dir "/vendor/color-theme-wunki/color-theme-wunki.el"))

;; load the theme
(color-theme-vibrant-ink)