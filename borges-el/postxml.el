;; TODO: Me falta lo de aceptar cookies
(require 'url)

(defun my-url-http-post (url args)
  "Send ARGS to URL as a POST request."
  (let ((url-request-method "POST")
        (url-request-extra-headers
;;;          '(("Content-Type" . "application/x-www-form-urlencoded")))
         '(("Content-Type" . "application/xml")))
        (url-request-data
         (mapconcat (lambda (arg)
                      (concat (url-hexify-string (car arg)) "=" (url-hexify-string (cdr arg)))) args "&")))
    ;; if you want, replace `my-switch-to-url-buffer' with `my-kill-url-buffer'
    (url-retrieve url 'my-switch-to-url-buffer)))

(defun my-kill-url-buffer (status)
  "Kill the buffer returned by `url-retrieve'."
  (kill-buffer (current-buffer)))

(defun my-switch-to-url-buffer (status)
  "Switch to the buffer returned by `url-retreive'.
    The buffer contains the raw HTTP response sent by the server."
  (switch-to-buffer (current-buffer)))

;; (my-url-http-post "http://localhost:3000/essays.xml" '(("title" . "yeah") ("content" . "hellloooo")))

;; otros intentos...
;; funciono!!!
;; ahora modificar la aplicacion de rails para que no acepte forgery...
;; y funciona!!!!!!!
(defun wally-url-http-post-hardcoded (url)
  "Send ARGS to URL as a POST request."
  (let ((url-request-method "POST")
        (url-request-extra-headers '(("Content-Type" . "application/xml")))
        (url-request-data "<essay><title>Hola choche</title><content>yeah!!!!!!!</content></essay>"))
    (url-retrieve url 'my-switch-to-url-buffer))
  )

;; EXAMPLE
;; (wally-url-http-post-hardcoded "http://localhost:3000/essays.xml")

;; Ejemplo concatenando el request
(defun wally-create-essay(url)
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
        )                                         ;end of let
    (url-retrieve url 'my-switch-to-url-buffer)))                                       ;end of defun

;; (wally-create-essay "http://localhost:3000/essays.xml")

;; Haciendo la funcion interactive. Funciona. Ahora hacer que se pueda aceptar utf-8
(defun wally-create-essay-interactive ()
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
                                  "</essay>")))
    (url-retrieve "http://localhost:3000/essays.xml" 'my-switch-to-url-buffer)))

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

;; extra, crear un sms con get, pasandole los parametros a mano
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


(defun wally-send-sms ()
  "segunda version con espacios en el mensaje"
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
                          "message="
                          (url-hexify-string (read-from-minibuffer "Message: ")))
                  'my-switch-to-url-buffer)))

(defun wally-send-sms ()
  "tercera version, escogiendo el telefono segun el nombre"
  (interactive)
  (let ((url-request-method "GET")
        (nombre (downcase (read-from-minibuffer "A quien: "))))
    (url-retrieve (concat "http://messages.staf621.com/?"
                          "name="
                          (if (equal nombre "mariko") "mariko&number=3312540884&")
                          ;; esto va a ser concatenado.
                          ;; "mariko" "&number=3312540884&"
                          "message="
                          (url-hexify-string (read-from-minibuffer "Message: ")))
                  'my-switch-to-url-buffer)))

;; (let ((nombre (read-from-minibuffer "Quien: ")))
;; (message nombre))
;; (downcase (read-from-minibuffer "q: "))
(wally-send-sms)

;; (url-hexify-string (read-from-minibuffer "Message: "))
;; (url-hexify-string "yeah aaaa")
;; Termine de ver watchmen, regular, salvo el final

;; la funcion completa como deberia de quedar. debia de pedir el numero primero...
(let ((nombre (downcase (read-from-minibuffer "a quien: "))))
  (concat "http://messages.staf621.com/?"
          "name="
          (if (equal nombre "mariko") "mariko&number=3312540884&"
            (equal nombre "wally") "wally&number=3312540884&")
          ;; esto va a ser concatenado.
          ;; "mariko" "&number=3312540884&"
          "message="
          (url-hexify-string (read-from-minibuffer "Message: "))))


;; acomodando los nombres
;; http://messages.staf621.com/?number=3312540884&name=mariko&message=holamariko
(let ((nombre (downcase (read-from-minibuffer "a quien: ")))
      (url-request-method "GET"))
  (concat "http://messages.staf621.com/?"
          (if                           ;lista de contactos
              (equal nombre "mariko") "number=3312540884&name=wally&"
            (equal nombre "wally") "number=3312540884&name=wally&"
            (equal nombre "choche") "number=3334000534&name=wally&"
            )
          ;; esto va a ser concatenado.
          ;; "mariko" "&number=3312540884&"
          "message="
          (url-hexify-string (read-from-minibuffer "Message: "))))

;; ACOMODANDO LA FUNCION
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

(defun my-switch-to-url-buffer (status)
  "Switch to the buffer returned by `url-retreive'.
    The buffer contains the raw HTTP response sent by the server."
  (switch-to-buffer (current-buffer)))


(wally-send-sms)
