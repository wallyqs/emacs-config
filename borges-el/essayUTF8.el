(require 'url)

(defun my-switch-to-url-buffer (status)
  "Switch to the buffer returned by `url-retreive'.
    The buffer contains the raw HTTP response sent by the server."
  (switch-to-buffer (current-buffer)))

;; create-essay with utf-8. Strings should be hexified...
;; &#26085;&#26412;&#35486; 日本語
;; &#241 es una enhe ñ
;; el problema va a ser cuando emacs encodee los caracteres del textile...
;; voy a tener que buscar los caracteres que sean utf8 y codificarlos en el html.
;; es que en teoria esto se deberia de poder no???
(defun wally-create-essay-utf8-hardcoded ()
  "interactive function for feeding the borges RESTful interface"
  (interactive)
  (let ((url-request-method "POST")
        (url-request-extra-headers '(("Content-Type" . "application/xml")))
        (url-request-data (concat "<essay>"
                                  "<title>" "Utf-8!!!" "</title>"
                                  "<content>"
;;;                               ( "日本語")
;;;                               "&#26085;&#26412;&#35486;"
;;;                               (eval (sgml-name-char "あ"))
                                  "</content>"
                                  "</essay>")))
    (url-retrieve "http://localhost:3000/essays.xml" 'my-switch-to-url-buffer)))

;; Todo hexify-string...
;; hacer un sgml-name-char de cada uno de los caracteres???&#12354;
;; (wally-create-essay-utf8-hardcoded)
;; (sgml-name-char "あ") &#12354;
;; (sgml-name-char "日") &#26085;
;; (sgml-name-char "ñ") &ntilde;

;; (sgml-name-char "あ")
;; (sgml-namify-char "あ")
;; (sgml-char-names "あ")
;; (hexify-string "a")

;; http://messages.staf621.com/?number=3312540884&name=mariko&message=holamariko
;; http://messages.staf621.com/?number=3312540884&name=mariko&message=holamariko
