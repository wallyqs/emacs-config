(require 'comint)

(defvar fcsh-mode-map
(let ((fcsh-mode-map (copy-keymap comint-mode-map)))
(define-key fcsh-mode-map [(up)] 'comint-previous-input)
(define-key fcsh-mode-map [(down)] 'comint-next-input)
fcsh-mode-map
)
"Keymap for fcsh major mode")

(defvar fcsh-mode-hook nil
"Functions to run when fcsh mode is actived.")

(defvar fcsh-input-ring-file-name "~/.fcsh_history"
"*When non-nil, file name used to store Fcsh shell history information.")

(defun fcsh-mode ()
"Major mode for running the fcsh, flex compiler shell"
(interactive)
(comint-mode)
(setq major-mode 'fcsh-mode)
(setq mode-name "FCSH")
(use-local-map fcsh-mode-map)

(setq comint-prompt-regexp "^\\(fcsh\\) ")
(setq comint-eol-on-send t)
(setq comint-input-ignoredups t)
(setq comint-scroll-show-maximum-output t)
(setq comint-scroll-to-bottom-on-output t)

;; Some older versions of comint don't have an input ring.
(if (fboundp 'comint-read-input-ring)
(progn
(setq comint-input-ring-file-name fcsh-input-ring-file-name)
(comint-read-input-ring t)
(make-local-variable 'kill-buffer-hook)
(add-hook 'kill-buffer-hook 'comint-write-input-ring)))

(run-hooks 'fcsh-mode-hook))

(defun fcsh ()
"Run an inferior fcsh, with I/O through buffer *fcsh*.
If buffer exists but fcsh process is not running, make new process.
If buffer exists and fcsh process is running, just switch to *fcsh*.
The buffer is put in fcsh-mode.

\(Type \\[describe-mode] in the fcsh buffer for a list of commands.)"
(interactive)
(cond ((not (comint-check-proc "*fcsh*"))
(set-buffer (make-comint "fcsh" "~/flex_sdk_3/bin/fcsh"))
(fcsh-mode)))
(pop-to-buffer "*fcsh*"))


(defun fcsh-command (cmd)
"Run a command in the fcsh shell"
(interactive "scommand?")
(let ((old-buffer (current-buffer)))
(cond ((not (comint-check-proc "*fcsh*"))
;; (set-buffer (make-comint "fcsh" "fcsh"))
(set-buffer (make-comint "fcsh" "~/flex_sdk_3/bin/fcsh"))       
(fcsh-mode)))
(set-buffer "*fcsh*")
(goto-char (marker-position (process-mark (get-buffer-process (current-buffer)))))
(insert cmd)
(comint-send-input)
(switch-to-buffer old-buffer)))

(defun fcsh-repeat-last ()
"Repeat last command in fcsh"
(interactive)
(let ((old-buffer (current-buffer)))
(cond ((not (comint-check-proc "*fcsh*"))
(set-buffer (make-comint "fcsh" "fcsh"))
(fcsh-mode)))
(set-buffer "*fcsh*")
(goto-char (marker-position (process-mark (get-buffer-process (current-buffer)))))
(call-interactively 'comint-previous-input)
(comint-send-input)
(switch-to-buffer old-buffer)))

;; (set-buffer (make-comint "fcsh" "~/flex_sdk_3/bin/fcsh"))
;; (set-buffer (make-comint "fcsh" (to-string flex-path)))
;; (setq flex-path "/home/waldemarpc/flex_sdk_3/bin/fcsh")
;; (message flex-path)
;; (set-buffer (make-comint "fcsh" flex-path))
