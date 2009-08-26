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

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun wally-index-essays-html ()
  "hacerle un index y que me de el html"
  (let ((url-request-method "GET"))
    (url-retrieve "http://localhost:3000/essays" 'my-switch-to-url-buffer)))

(defun wally-index-essays-xml ()
  "hacerle un index y que me de el xml, despues esto se debe de parsear"
  (interactive)
  (let ((url-request-method "GET"))
    (url-retrieve "http://localhost:3000/essays.xml" 'my-switch-to-url-buffer)))

;; FIXME: Define the functionality. How will I decide where I want to write???
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
        )                               ;end of let varlist
    (url-retrieve
     ;; (concat "http://localhost:3000/" "essays" ".xml")
     (read-from-minibuffer "Url: ")
     'my-switch-to-url-buffer)))

;; FIXME:  Hacer que se pueda aceptar utf-8
(defun wally-create-essay()
  "interactive function for feeding the borges RESTful interface"
  (interactive)
  (let ((url-request-method "POST")
        (url-request-extra-headers '(("Content-Type" . "application/xml")))
        (url-request-data (concat "<essay>"
                                  "<title>"
                                  (read-from-minibuffer "Essay title: ")
                                  "</title>"
                                  "<content>"
                                  (buffer-string) ; here is the text that will be posted
                                  "</content>"
                                  "</essay>"))
        )                               ;end of let varlist
    (url-retrieve "http://127.0.0.1:3000/essays.xml" 'my-switch-to-url-buffer)))

;; Borges development below
(defun wally-update-essay()
  "interactive function for feeding the borges RESTful interface"
  (interactive)
  (let ((url-request-method "PUT")
        (url-request-extra-headers '(("Content-Type" . "application/xml")))
        (url-request-data (concat "<essay>"
                                  "<title>"
                                  (read-from-minibuffer "Essay title: ")
                                  "</title>"
                                  "<content>"
                                  (buffer-string) ; here is the text that will be posted
                                  "</content>"
                                  "</essay>"))
        )                               ;end of let varlist
    (url-retrieve (concat "http://127.0.0.1:3000/essays/" (read-from-minibuffer "Which one?(number) ") ".xml") 'my-switch-to-url-buffer)))

;; 26 de Agosto del 2009
;; Getting the buffer for editing purposes ................................................................................
(defun wally-parse-getted-buffer (status)
  "Switch to the buffer returned by `url-retreive'.
    The buffer contains the raw HTTP response sent by the server."
  (switch-to-buffer (current-buffer)))

(defun wally-get-essay-and-write()
  "Esta funcion hace un get a un essay y te abre un buffer sobre el cual puedes editarlo"
  (interactive)
  (let ((url-request-method "GET")
        (url-request-extra-headers '(("Content-Type" . "application/xml")))
        )                               ;end of let varlist
    (url-retrieve (concat "http://127.0.0.1:3000/essays/" (read-from-minibuffer "Number: ") ".xml") 'wally-parse-getted-buffer)))


;; FIXME: learning elisp. Super development. 
;; Debo de hacer el get del essay, 
;; meter el xml adentro de otro buffer. 
;; parsear el xml y obtener lo que hay dentro de <content></content>
;; y a eso meterlo de otro buffer para editar. 
;; una vez que se guarda, se tiene que hacer el put de que se edito el recurso.
(defun wally-get-essay-and-write-lambda()
  "Esta funcion hace un get a un essay y te abre un buffer sobre el cual puedes editarlo"
  (interactive)
  (let ((url-request-method "GET")
        (url-request-extra-headers '(("Content-Type" . "application/xml")))
        )                               ;end of let varlist
    (url-retrieve (concat "http://127.0.0.1:3000/essays/"
                          ;; (read-from-minibuffer "Number: ")
                          "5.xml")
                  ;; CALLBACK made by url-retrieve
                  ;; (lambda (status)
                  ;; (print status)      ; si no ocurrieron eventos va a ser nil
                  ;; (current-buffer)
                  ;; meter el contenido del current-buffer en post
                  'wally-append-to-buffer
                  ;; )                   ; end of CALLBACK
                  )))

(defun wally-append-to-buffer (status)
  ;; tal vez se le pueda quitar lo de interactive
  (interactive
   (list (read-buffer "Append to buffer: " (other-buffer
                                            (current-buffer) t))
         (region-beginning) (region-end)))
  (let ((oldbuf (current-buffer)))
    (save-excursion
      (let* ((append-to (get-buffer-create "tempxml"))
             (windows (get-buffer-window-list append-to t t))
             point)
        (set-buffer append-to)
        (setq point (point))
        (barf-if-buffer-read-only)
	(goto-char 243)			;nos movemos hasta el lugar donde empieza el xml
	;; obvio debe de insertar hasta lo del final, el tamanho siempre va a ser variable
        (insert-buffer-substring oldbuf 243 630)
        (dolist (window windows)
          (when (= (window-point window) point)
            (set-window-point window (point))))))))

;; development
(wally-get-essay-and-write-lambda)




