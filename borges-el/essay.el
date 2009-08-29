(require 'url)
(require 'xml)

;; Support functions. CALLBACKs
(defun my-kill-url-buffer (status)
  "Kill the buffer returned by `url-retrieve'."
  (kill-buffer (current-buffer)))

(defun my-switch-to-url-buffer (status)
  "Switch to the buffer returned by `url-retreive'.
    The buffer contains the raw HTTP response sent by the server."
  (switch-to-buffer (current-buffer)))

;;  --------------------------- to-be-done functions  ------------------------------------------------------
;; TODO: parsear la lista
(defun wally-index-essays ()
  "Esta funcion me debe de dar el index de los essays que tengo en total 
y ponerme la lista parseada en un buffer que se llame. *essays index*"
  (interactive)
  (let ((url-request-method "GET"))
    (url-retrieve "http://localhost:3000/essays.xml" 'my-switch-to-url-buffer)))

;; TODO: Se deben de poder parsear cierto tipo de META-DATOS COMO LO HACE EL WEBLOGGER. Por ejemplo,
;; (1) sea posible decirle cual es el titulo del archivo. El cual puede o no llamarse como un numero.
;; El titulo que define autor se le podra hacer GET asi: nuevo-titulo-autor.
;; Que pasa si no le quiere poner titulo? Luego.
;; (2) Otro approach es que el titulo del ensayo sea el nombre del archivo.
;; Si ya existe un essay con ese nombre entonces lo crea como otra version. ~/essays/nuevo-titulo-autor-2
;; Hacer dos funciones para los tipos de approaches.
(defun wally-create-essay-with-title()
  "Funcion que crea un ensayo haciendo un post de todo lo que esta en el buffer."
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


;; TODO: no te deberia de pedir dos veces el nombre del essay. Se debe de meter de la 
;; let varlist.
(defun wally-update-essay-with-title()
  "Funcion que le hace update a un essay si le das el titulo, 
debe de tomar el titulo debe de tomar el titulo de la
misma forma que lo hace wally-create-essay-with-title"
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
     (concat "http://127.0.0.1:3000/essays/" 
	     (read-from-minibuffer "Which? (title-like-this) ") 
	     ".xml")
     'my-switch-to-url-buffer)))

;; 28 de Agosto del 2009
;; -------------------------------------  new development area -----------------------------------
(defun wally-get-essay-xml()
  "Funcion que te da el xml de un essay "
  (interactive)
  (let ((url-request-method "GET")
        (url-request-extra-headers '(("Content-Type" . "application/xml")))
        )                               ;end of let varlist
    (url-retrieve (concat "http://127.0.0.1:3000/essays/" 
			  (read-from-minibuffer "Which? (name): ") 
			  ".xml") 
		  'my-switch-to-url-buffer)))

;; TODO: Esta funcion te debe de abrir un buffer para poder editar el archivo 
;; y hacer un PUT con wally-update-essay-with-title al momento de guardarlo.
;; Por el momento del PUT de rails no sirve porque no he puesto bien la ruta
;; como deberia de ser.
(defun wally-get-essay-and-write-now()
  "Hace el GET de un recurso y te abre un buffer para poder editarlo. 
Es el analogo al edit, de hecho se deberia de llamar edit-essay-with-title"
  (interactive)
  (let ((url-request-method "GET")o
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

;; TODO: Le falta mucho a esta funcion para poder quedar bien.
;; deberia de llamar al buffer de la misma forma que se llama el essay.
;; Asi para guardarlo me refiero al nombre del buffer. Por lo menos ese
;; es el approach que tengo ahorita. Y ademas quitarle todo ese desastre 
;; que tiene adentro. Por lo menos entender que es lo que esta sucediendo.
(defun wally-response-create-buffer (response-buffer)
  "Parse the response and append it into a buffer. Crea un 
nuevo buffer *essay* en donde se encuentra lo que parseo"
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

