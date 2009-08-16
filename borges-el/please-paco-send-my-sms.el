(require 'url)
;; Dispnible en: http://pastie.org/private/6oow5x5bn1swwhbuzgiiiw
;; y tambien en http://pastie.org/private/xabcwpsw6rfb0wgycwcxwa
;; elisp para colgarse del webservice que hizo paco para mandar mensajes desde emacs
;; para instalar escribir en el ~/.emacs (load-file "~/please-paco-send-my-sms.el")

(defun my-switch-to-url-buffer (status)
  "Switch to the buffer returned by `url-retreive'.
    The buffer contains the raw HTTP response sent by the server."
  (switch-to-buffer (current-buffer)))

(defun please-paco-send-my-sms ()
  "tercera version, escogiendo el telefono segun el nombre"
  (interactive)
  (let ((url-request-method "GET")
        (nombre (downcase (read-from-minibuffer "A quien: "))))
    (url-retrieve (concat "http://messages.staf621.com/?"
                          (if                           ;lista de contactos
                              (equal nombre "mariko") "number=3312540884&name=wally&"
                            (equal nombre "wally") "number=3312540884&name=wally&"
                            (equal nombre "choche") "number=3334000534&name=wally&"
                            )
                          "message="
                          (url-hexify-string (read-from-minibuffer "Message: ")))
                  'my-switch-to-url-buffer)))

(global-set-key (kbd "<f9>") 'please-paco-send-my-sms)

