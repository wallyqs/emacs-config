(require 'url)

;; elisp para colgarse del webservice que hizo paco para mandar mensajes desde emacs
(defun my-switch-to-url-buffer (status)
  "Switch to the buffer returned by `url-retreive'.
    The buffer contains the raw HTTP response sent by the server."
  (switch-to-buffer (current-buffer)))

(defun wally-send-sms ()
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

