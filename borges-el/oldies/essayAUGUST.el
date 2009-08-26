;; TODO: Me falta lo de aceptar cookies
(require 'url)

;; FIXME:  estas convertirlas en lambdas... luego 
(defun my-kill-url-buffer (status)
  "Kill the buffer returned by `url-retrieve'."
  (kill-buffer (current-buffer)))

(defun my-switch-to-url-buffer (status)
  "Switch to the buffer returned by `url-retreive'.
    The buffer contains the raw HTTP response sent by the server."
  (switch-to-buffer (current-buffer)))

;; funcion que si sirve
(defun wally-send-sms1 ()
  "primera version, mensajes sin espacios"
  (interactive)
  (let ((url-request-method "GET"))
    ;; (url-retrieve "http://messages.staf621.com/?number=3312540884&name=mariko&message=holamarikootravez"
    ;; 'my-switch-to-url-buffer)
    (url-retrieve (concat "http://messages.staf621.com/?"
                          "name="   "mariko"
                          "&"
                          "number=" "3312540884"
                          "&"
                          ;; hacer que convierta los espacios en %20 por ejemplo
                          "message=" (read-from-minibuffer "Message: "))
                  'my-switch-to-url-buffer)))

;; good con el html
(defun wally-index-essays-html ()
  "hacerle un index y que me de el html"
  (interactive)
  (let ((url-request-method "GET"))
    ;; (url-retrieve "http://messages.staf621.com/?number=3312540884&name=mariko&message=holamarikootravez"
    ;; 'my-switch-to-url-buffer)
    (url-retrieve "http://127.0.0.1:3005/essays" 'my-switch-to-url-buffer)))

;; good con el xml
(defun wally-index-essays-xml ()
  "hacerle un index y que me de el html"
  (interactive)
  (let ((url-request-method "GET"))
    ;; (url-retrieve "http://messages.staf621.com/?number=3312540884&name=mariko&message=holamarikootravez"
    ;; 'my-switch-to-url-buffer)
    (url-retrieve "http://127.0.0.1:3005/essays.xml" 'my-switch-to-url-buffer)))

(defun wally-create-essay-provide-url(url)
  "Function for feeding a RESTful interface I'm creating"
  (interactive)
  (let ((url-request-method "POST")
        (url-request-extra-headers '(("Content-Type" . "application/xml")))
        (url-request-data (concat "<essay>"
                                  "<title>"
                                  (read-from-minibuffer "Essay title: ")
                                  "</title>"
                                  "<content>"
                                  (buffer-string)
                                  "</content>"
                                  "</essay>"))	
        )				;end of let varlist
    (url-retrieve (read-from-minibuffer "Url: ") 'my-switch-to-url-buffer)))

;; Haciendo la funcion interactive. Ahora hacer que se pueda aceptar utf-8
;; quitar el my-switch-to-url-buffer y poner una lambda mejor...
(defun wally-create-essay-textile ()
  "interactive function for feeding the borges RESTful interface"
  (interactive)
  (let ((url-request-method "POST")
        (url-request-extra-headers '(("Content-Type" . "application/xml")))
        (url-request-data (concat "<essay>"
                                  "<title>"
                                  (read-from-minibuffer "Essay title: ")
                                  "</title>"
                                  "<content>"
                                  (buffer-string)
                                  "</content>"
                                  "</essay>"))
	)				;end of let varlist
    (url-retrieve "http://127.0.0.1:3005/essays.xml" 'my-switch-to-url-buffer)))

;; create-essay with utf-8. Strings should be hexified...
;; &#26085;&#26412;&#35486; 日本語
;; &#241 es una enhe ñ
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

