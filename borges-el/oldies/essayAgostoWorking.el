(require 'url)
(require 'xml)

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

;;  --------------------------- done functions  ------------------------------------------------------
;; FIXME:  Hacer que se pueda aceptar utf-8 --> DONE!!!
(defun wally-create-essay()
  "interactive function for feeding the borges RESTful interface"
  (interactive)
  (let ((url-request-method "POST")
        (url-request-extra-headers '(("Content-Type" . "application/xml")))
        (url-request-data
         (encode-coding-string (concat "<essay>"
                                       "<title>"
                                       (read-from-minibuffer "Essay title: ")
                                       "</title>"
                                       "<content>"
                                       (buffer-string) ; here is the text that will be posted
                                       "</content>"
                                       "</essay>") 'utf-8)
         )
        )                               ;end of let varlist
    (url-retrieve "http://127.0.0.1:3000/essays.xml" 'my-switch-to-url-buffer)))

;; FIXME: Borges development below... It is more like a replace.
(defun wally-update-essay()
  "interactive function for feeding the borges RESTful interface"
  (interactive)
  (let ((url-request-method "PUT")
        (url-request-extra-headers '(("Content-Type" . "application/xml")))
        (url-request-data
         (encode-coding-string (concat "<essay>"
                                       "<title>"
                                       (read-from-minibuffer "Essay title: ")
                                       "</title>"
                                       "<content>"
                                       (buffer-string) ; here is the text that will be posted
                                       "</content>"
                                       "</essay>") 'utf-8)
         )
        )                               ;end of let varlist
    (url-retrieve
     (concat "http://127.0.0.1:3000/essays/" (read-from-minibuffer "Which one?(number) ") ".xml")
     'my-switch-to-url-buffer)))

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
                          "24.xml")
                  ;; CALLBACK made by url-retrieve
                  ;; (lambda (status)
                  ;; (print status)      ; si no ocurrieron eventos va a ser nil
                  ;; (current-buffer)
                  ;; meter el contenido del current-buffer en post
                  'wally-append-to-buffer
                  ;; )                   ; end of CALLBACK
                  )))

;; debo de crear una funcion que me de el point donde se encuentra <?xml
;; Trying to process the response ---------------------------------------------------!!!!!!!!!!!!!!
(defun wally-get-essay-and-process()
  "Esta funcion hace un get a un essay y te abre un buffer sobre el cual puedes editarlo"
  (interactive)
  (let ((url-request-method "GET")
        (url-request-extra-headers '(("Content-Type" . "application/xml"))))
;;;     (url-retrieve (concat "http://127.0.0.1:3000/essays/24.xml")
;;;                   'wally-append-to-buffer)
    ;; esto me devuelve una string con los contenidos del buffer
    (wally-response-create-buffer
     (url-retrieve-synchronously "http://127.0.0.1:3000/essays/25.xml"))
    ))

(defun wally-get-essay-and-write-now()
  "Esta y la de abajo son las buenas. Hace el get de un recurso y te permite escribir en el despues"
  (interactive)
  (let ((url-request-method "GET")
        (url-request-extra-headers '(("Content-Type" . "application/xml"))))
;;;     (url-retrieve (concat "http://127.0.0.1:3000/essays/24.xml")
;;;                   'wally-append-to-buffer)
    ;; esto me devuelve una string con los contenidos del buffer
    (wally-response-create-buffer
     (url-retrieve-synchronously
      (concat "http://127.0.0.1:3000/essays/"
              (read-from-minibuffer "Which one? (id number)")
              ".xml")			; finished concatenating
      )					; end of url-retrieval
     )					; buffer created
    )					; end of let
  )


(defun wally-response-create-buffer (response-buffer)
  "Parse the response and append it into a buffer."
  (let ((retval nil))
    (with-current-buffer response-buffer
      (goto-char (point-min))
      (when (looking-at "^HTTP/1.* 200 OK$")
        (re-search-forward "^$" nil t 1)
        (setq retval (buffer-substring-no-properties (point) (point-max))))
      (kill-buffer response-buffer))
    (setq root (with-temp-buffer
                 (insert "\n" retval "\n")
                 (goto-char (point-min))
                 (while (re-search-forward "\r" nil t)
                   (replace-match ""))
                 (xml-parse-region (point-min) (point-max)))) ; gets the whole xml into a list structure
    (setq essay (car root))
    (setq content (car (xml-get-children essay 'content)))
    (setq inner-content (car (xml-node-children content)))
    ;; AQUI YA TENGO EL INNER-CONTENT Y LO PUEDO METER DENTRO DE UN BUFFER
;;;     (message "%s" inner-content)
    (let ((oldbuf (current-buffer)))
      (save-excursion
        (let* ((append-to (get-buffer-create "*new_essay*"))
               (windows (get-buffer-window-list append-to t t))
               point)
          (set-buffer append-to)
          (setq point (point))
          (barf-if-buffer-read-only)
;;;       (insert-buffer-substring oldbuf 2 20)
          (insert-string inner-content)
          (dolist (window windows)
            (when (= (window-point window) point)
              (set-window-point window (point))))))
      )                                 ;end of minor let
    )                                   ; end of big let
  )

;; latest development
;; (wally-get-essay-and-process)
;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(defun wally-really-process-normal-response (response-buffer)
  "Example of how to parse the xml response"
  (let ((retval nil))
    (with-current-buffer response-buffer
      (goto-char (point-min))
      (when (looking-at "^HTTP/1.* 200 OK$")
        (re-search-forward "^$" nil t 1)
        (setq retval (buffer-substring-no-properties (point) (point-max))))
      (kill-buffer response-buffer))
    (setq root (with-temp-buffer
                 (insert "\n" retval "\n")
                 (goto-char (point-min))
                 (while (re-search-forward "\r" nil t)
                   (replace-match ""))
                 (xml-parse-region (point-min) (point-max)))) ; gets the whole xml into a list structure
    (setq essay (car root))
    (setq content (car (xml-get-children essay 'content)))
    (setq inner-content (car (xml-node-children content)))
    ;; AQUI YA TENGO EL INNER-CONTENT Y LO PUEDO METER DENTRO DE UN BUFFER
    (message "%s" inner-content)
    )                                   ; end of let
  )

(defun wally-process-normal-response (response-buffer)
  "Process the REST response in RESPONSE-BUFFER."
  (let ((retval nil))
    (with-current-buffer response-buffer
      (goto-char (point-min))
      (when (looking-at "^HTTP/1.* 200 OK$")
        (re-search-forward "^$" nil t 1)
        (setq retval (buffer-substring-no-properties (point) (point-max))))
      (kill-buffer response-buffer))
    (with-temp-buffer
      (insert "\n" retval "\n")
      (goto-char (point-min))
      (while (re-search-forward "\r" nil t)
        (replace-match ""))
      (xml-parse-region (point-min) (point-max))
      )))


;; Esto me da una lista con los elementos del xml parseados en una lista
(defun wally-process-response (response-buffer)
  "Process the SOAP response in RESPONSE-BUFFER."
  (let ((retval nil))
    (with-current-buffer response-buffer
      (goto-char (point-min))
      (when (looking-at "^HTTP/1.* 200 OK$")
        (re-search-forward "^$" nil t 1)
        (setq retval (buffer-substring-no-properties (point) (point-max))))
      (kill-buffer response-buffer))
    (with-temp-buffer
      (insert "\n" retval "\n")
      (goto-char (point-min))
      (while (re-search-forward "\r" nil t)
        (replace-match ""))
      (xml-parse-region (point-min) (point-max)))))


;; some examples I found on the Internets ---------------------------------------------
;; (defun soap-request (url data)
;;   "Send and process SOAP request to URL with DATA."
;;   (let* ((url-request-extra-headers
;;           `(("Content-type" . "text/xml; charset=\"utf-8\"")
;;             ("SOAPAction" . ,(format "%S" url))))
;;          (url-request-method "POST")
;;          (url-request-data
;;           (concat "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n"
;;                   data)))
;;     (soap-process-response (url-retrieve-synchronously url))))


;; (defun wally-process-response (response-buffer)
;;   "Process the SOAP response in RESPONSE-BUFFER."
;;   (let ((retval nil))
;;     (with-current-buffer response-buffer
;;       (goto-char (point-min))
;;       (when (looking-at "^HTTP/1.* 200 OK$")
;;         (re-search-forward "^$" nil t 1)
;;         (setq retval (buffer-substring-no-properties (point) (point-max))))
;;       (kill-buffer response-buffer))
;;     (with-temp-buffer
;;       (insert "\n" retval "\n")
;;       (goto-char (point-min))
;;       (while (re-search-forward "\r" nil t)
;;         (replace-match ""))
;;       (xml-parse-region (point-min) (point-max)))))

(defun wally-append-to-buffer (status)
  ;; tal vez se le pueda quitar lo de interactive
  (let ((oldbuf (current-buffer)))
    (save-excursion
      (let* ((append-to (get-buffer-create "tempxml"))
             (windows (get-buffer-window-list append-to t t))
             point)
        (set-buffer append-to)
        (setq point (point))
        (barf-if-buffer-read-only)
;;;  (re-search-forward "<?xml" nil t)
;;;  (point)
;;;         (goto-char 243)                 ;nos movemos hasta el lugar donde empieza el xml
        ;; obvio debe de insertar hasta lo del final, el tamanho siempre va a ser variable
        ;; encontrar la posicion donde empieza el <?xml...
;;;         (insert-buffer-substring oldbuf 243 250)
        (dolist (window windows)
          (when (= (window-point window) point)
            (set-window-point window (point)))))))
  )

;; development
;; (wally-get-essay-and-write-lambda)

;; pruebas -------------------------------------

;; (wally-get-essay-and-process)






