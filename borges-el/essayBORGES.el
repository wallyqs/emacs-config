;; Elisp interface for the Borges API.
;;  Current functionality:
;;
;;  * Essay posting, reading and editing
;;  * Authorization
;;
;; TODO: Se deben de poder parsear cierto tipo de META-DATOS COMO LO HACE EL WEBLOGGER. Por ejemplo:
;;
;; (1) Sea posible decirle cual es el titulo del archivo. El cual puede o no llamarse como un numero.
;; El titulo que define autor se le podra hacer GET asi: nuevo-titulo-autor.
;; Que pasa si no le quiere poner titulo? Luego.
;;
;; (2) Otro approach es que el titulo del ensayo sea el nombre del archivo.
;; Si ya existe un essay con ese nombre entonces lo crea como otra version. ~/essays/nuevo-titulo-autor-2
;; Hacer dos funciones para los tipos de approaches.
;; Quiero hacer un quick login de fallback
;;
;; (3) Necesito de una funcion para crear un nuevo post sin tener que tomar el
;; nombre del buffer. wally-new-essay por ejemplo
;;
;; (4) Quiero que cuando no hecho login y creo un essay me pida que me loggee.
;; Esto lo voy a hacer hasta que reciba un OK creo...
;; 
;; 
;; 
;; 4 de Septiembre del 2009
;; -------------------------------------  new development area -----------------------------------
;; Debo de hacer una funcion que al llamarla te cree un buffer en ~/escritos/essays/
;; O hacer un hook que en el momento que abro un archivo en la carpeta de escritos me va a poner las
;; opciones que quiero ya por default.


;; CURRENT HACK
;; poniendole el parametro de is_private a los posts que se hacen.


(require 'url)
(require 'xml)
(require 'url-http)



(defun wally-quick-login ()
  "Esta funcion me debe de dar el index de los essays que tengo en total
y ponerme la lista parseada en un buffer que se llame. *essays index*"
  (interactive)
  (let ((url-request-method "GET")
        (url-request-extra-headers
         `(("Content-Type" . "application/xml")
           ("Authorization" . ,(concat "Basic "
                                       (base64-encode-string
                                        (concat
                                         (read-string "Username: ")
                                         ":"
                                         (read-passwd "Password: ")
                                         ))))))) ;end of let varlist
    (url-retrieve "http://borges.waricho.com/account"
                  (lambda (status)
                    (kill-buffer (current-buffer)))
                  )))


(defun wally-new-essay ()
  "Funcion que te crea una buffer con el modo de textile, le hace push,
y le pone como default que es privado.
El buffer es en realidad un draft. En el response del create, voy a recibir
el DRAFT ID el cual voy a usar para hacerle push. Supongo que voy a tener una ruta
que se llama essays/drafts.
Pero eso es en el futuro, ahorita lo unico que
quiero es que me de un buffer al cual yo le pueda poner nombre.
"
  (interactive)
  (let* (
         (title (read-string "Name: "))
         )
    (get-buffer-create title)
    (set-buffer title)
    (textile-mode)
    (set-window-buffer (selected-window) title)
    (local-set-key "\C-cs" 'wally-create-essay-buffer-name)
    )                                   ;end of let
  )

(defun wally-change-privacy ()
  "Funcion para cambiar si un essay es privado o no"
  (interactive)
  (let* (
         (url-request-method "PUT")
         (url-request-extra-headers '(("Content-Type" . "application/xml")))
         (essay-title (read-string "De cual?: "))
         (url-request-data
          (encode-coding-string (concat "<essay>"
                                        "<title>"
                                        essay-title
                                        "</title>"
                                        "<is-private>"
					;; Quiero que esta parte diga yes or no
                                        (read-string "is private? (true or false)") 
                                        "</is-private>"
                                        "</essay>" ) 'utf-8 )
          )
         )                              ;end of varlist
    (url-retrieve 
     (concat "http://borges.waricho.com/essays/"
	     essay-title
	     ".xml")
     'my-kill-url-buffer)
    ))

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
                                       ;; (buffer-string) ; here is the text that will be posted
                                       (wally-quitar (buffer-string))
                                       "</content>"
                                       "</essay>") 'utf-8)
         )
        )                               ;end of let varlist
    (url-retrieve "http://borges.waricho.com/essays.xml" 'my-kill-url-buffer)))

(defun wally-create-essay-buffer-name()
  "Funcion que crea un ensayo haciendo un post de todo lo que esta en el buffer.
El recurso que se crea tiene el mismo nombre que el buffer."
  (interactive)
  (let* ((url-request-method "POST")
         (url-request-extra-headers '(("Content-Type" . "application/xml")))
         (essay-title (buffer-name))
         (url-request-data
          (encode-coding-string (concat "<essay>"
                                        "<title>"
                                        ;; (read-from-minibuffer "Essay title: ")
                                        essay-title
                                        "</title>"
                                        "<content>"
                                        ;; (buffer-string) ; here is the text that will be posted
                                        (wally-quitar (buffer-string))
                                        "</content>"
                                        "</essay>") 'utf-8)
          )
         )                               ;end of let varlist
    (url-retrieve "http://borges.waricho.com/essays.xml" 'my-kill-url-buffer)
    (textile-mode)
    (local-set-key "\C-cs" 'wally-update-essay-buffer-name)
    ))

;; TODO: Crear una funcion que tome el nombre del archivo y que con eso
;; haga el update.
;; Que lo que quiero que haga se realize con C-X C-S para eso hay que investigar
;; como hizo lo que hizo el weblogger
(defun wally-update-essay-with-title()
  "Funcion que le hace update a un essay si le das el titulo,
debe de tomar el titulo debe de tomar el titulo de la
misma forma que lo hace wally-create-essay-with-title"
  (interactive)
  (let*
      (
       (url-request-method "PUT")
       (url-request-extra-headers '(("Content-Type" . "application/xml")))
       (essay-title (read-from-minibuffer "Which? (title-like-this) "))
       (url-request-data
        (encode-coding-string (concat "<essay>"
                                      "<title>"
                                      ;; (read-from-minibuffer "Essay title: ")
                                      essay-title
                                      "</title>"
                                      "<content>"
                                      ;; (buffer-string) ; here is the text that will be posted
                                      (wally-quitar (buffer-string))
                                      "</content>"
                                      "</essay>") 'utf-8)
        )
       )                               ;end of let varlist
    (url-retrieve
     (concat "http://borges.waricho.com/essays/"
             ;; (read-from-minibuffer "Which? (title-like-this) ")
             ;; por que se llama hello aqui!????
             ;; por que let te deja tener los valores antiguos
             essay-title
             ".xml")
     'my-kill-url-buffer)))

(defun wally-update-essay-buffer-name()
  "Funcion que le hace update a un essay tomando el nombre del buffer como titulo.
Debe de tomar el titulo debe de tomar el titulo de la
misma forma que lo hace wally-create-essay-with-title
Pensar en que hacer para que se cree un archivo.
Creo que seria, si estan en la carpeta ~/escritos/essays/
En el momento que se guarde, C-X C-S. Se va a crear un nuevo recurso en internet,
asi como guardarse el archivo en la computadora.
"
  (interactive)
  (let*
      (
       (url-request-method "PUT")
       (url-request-extra-headers '(("Content-Type" . "application/xml")))
       (essay-title (buffer-name))
       (url-request-data
        (encode-coding-string (concat "<essay>"
                                      "<title>"
                                      essay-title
                                      "</title>"
                                      "<content>"
                                      ;; deberia de llamar la funciona para quitar los < y > del buffer
                                      ;; (buffer-string) ; here is the text that will be posted
                                      (wally-quitar (buffer-string))
                                      "</content>"
                                      "</essay>") 'utf-8)
        )
       )                               ;end of let varlist
    (url-retrieve
     (concat "http://borges.waricho.com/essays/"
             ;; (read-from-minibuffer "Which? (title-like-this) ")
             ;; por que se llama hello aqui!????
             ;; por que let te deja tener los valores antiguos
             essay-title
             ".xml")
     'my-kill-url-buffer)))

;; Debe de recibir una string y devolver una string ya sana
(defun wally-quitar(stringy)
  "Funcion para quitar los < y >, se debe de llamar cada
vez que se hace un push al servicio "
  (with-temp-buffer
    (insert stringy)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward ">" nil t)
        (replace-match "&gt;"))
      )
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "<" nil t)
        (replace-match "&lt;"))
      )
    (buffer-string)                     ; return del temp buffer
    ))

(defun wally-get-essay-and-write-now()
  "Hace el GET de un recurso y te abre un buffer para poder editarlo.
Es el analogo al edit, de hecho se deberia de llamar edit-essay-with-title"
  (interactive)
  (let ((url-request-method "GET")
        (url-request-extra-headers '(("Content-Type" . "application/xml"))))
    (wally-response-create-buffer2
     ;; EL RESPONSE BUFFER...
     (url-retrieve-synchronously
      (concat "http://borges.waricho.com/essays/"
              (read-from-minibuffer "Which one? (id number)")
              ".xml")                   ; finished concatenating
      )                                 ; end of url-retrieval
     )                                  ; buffer created
    )                                   ; end of let
  )

;; HAY UN PROBLEMA CUANDO ESTA VACIO EL CONTENT DEL ENSAYO...
(defun wally-response-create-buffer2 (response-buffer)
  "Parse the response and append it into a buffer. Crea un
nuevo buffer *essay* en donde se encuentra lo que parseo"
  (let* ((retval nil))
    (with-current-buffer response-buffer
      (goto-char (point-min))           ;ir al principio
      ;; It used to read the OK from the HTTP header but Passenger for example does not say anything...
      ;; (when (looking-at "^HTTP/1.* 200$")
      (when (looking-at "^HTTP/1.* 200") ; algunas veces no termina en OK o 200. deberia de poner regexp opcional
        (re-search-forward "^$" nil t 1)
        (setq retval
              (buffer-substring-no-properties (point) (point-max)) ; lo de adentro
              ))                                                   ; end of when

      ;; (kill-buffer response-buffer)     ;elimina el buffer de la response
      ) ;fin current-buffer

    ;; parse the xml string in a temporal buffer
    (setq root
          (with-temp-buffer
            (insert "\n" retval "\n")
            (goto-char (point-min))
            (while (re-search-forward "\r" nil t)
              (replace-match ""))       ; borrar los espacios
            (xml-parse-region (point-min) (point-max)))) ; gets the whole xml into a list structure

    (setq essay (car root))
    (setq content (car (xml-get-children essay 'content)))
    (setq inner-content (car (xml-node-children content))) ;end of parsing of content

    (setq essay-title-get (car (xml-get-children essay 'title)))
    (setq inner-title-get (car (xml-node-children essay-title-get))) ;end of parsing of title

    (save-excursion
      ;; Deberia de llamarse como el title, se deberia de parsear el title tambien
      (let* (
             ;; Parsear el titulo del archivo y se nombrea al buffer asi.
             (append-to (get-buffer-create inner-title-get))

             (windows (get-buffer-window-list append-to t t))
             point)
        (set-buffer append-to)
        (setq point (point))
        (barf-if-buffer-read-only)
        (insert-string inner-content)   ; meter el contenido dentro del buffer
        ;; FIXME: NO ENTIENDO PARA NADA ESTA PARTE ---------
        (dolist (window windows)
          (when (= (window-point window) point)
            (set-window-point window (point))))
        ;; FIXME: NO ENTIENDO PARA NADA ESTA PARTE ---------
        )                          ; end of let*
      )                                 ; end of excursion within the buffer

    (set-buffer inner-title-get)
    (textile-mode)
    ;; aqui hacer el override de local-set-key
    (local-set-key "\C-cs" 'wally-update-essay-buffer-name)
    (set-window-buffer (selected-window) inner-title-get)
    ;; (set-buffer-major-mode
    )                                   ; end of big let
  )



;; DEVELOPMENT FUNCTIONS ------------------------------------------------------------------------------------------------------------

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
      ;; (when (looking-at "^HTTP/1.* 200 OK$")
      (when (looking-at "^HTTP/1.* 200 OK")
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

(defun wally-get-essay-xml()
  "Funcion que te da el xml de un essay "
  (interactive)
  (let ((url-request-method "GET")
        (url-request-extra-headers '(("Content-Type" . "application/xml")))
        )                               ;end of let varlist
    (url-retrieve (concat "http://borges.waricho.com/essays/"
                          (read-from-minibuffer "Which? (name): ")
                          ".xml")
                  'my-switch-to-url-buffer)))


(defun wally-login-index-essays-xml ()
  "Esta funcion me debe de dar el index de los essays que tengo en total
y ponerme la lista parseada en un buffer que se llame. *essays index*"
  (interactive)
  (let ((url-request-method "GET")
        (url-request-extra-headers
         `(("Content-Type" . "application/xml")
           ("Authorization" . ,(concat "Basic "
                                       (base64-encode-string
                                        (concat
                                         (read-string "Username: ")
                                         ":"
                                         (read-passwd "Password: ")
                                         ))))))) ;end of let varlist
    (url-retrieve "http://borges.waricho.com/essays.xml"
                  (lambda (status)
                    (switch-to-buffer (current-buffer)))
                  )
    )                                   ;end of let
  )

;;  --------------------------- to-be-done functions  ------------------------------------------------------
;; ---------------------------------------------------------------------------------------------------------
;; TODO: parsear la lista y ponela en anything para que haga algo util
(defun wally-index-essays ()
  "Esta funcion me debe de dar el index de los essays que tengo en total
y ponerme la lista parseada en un buffer que se llame. *essays index*"
  (interactive)
  (let ((url-request-method "GET"))
    (url-retrieve "http://borges.waricho.com/essays.xml" 'my-switch-to-url-buffer))
  )


;; SUPPORT FUNCTIONS. CALLBACKS UTILS ���ܸ�Υƥ����� -----------------------------------------------------
(defun my-kill-url-buffer (status)
  "Kill the buffer returned by `url-retrieve'."
  (kill-buffer (current-buffer)))

(defun my-switch-to-url-buffer (status)
  "Switch to the buffer returned by `url-retreive'.
    The buffer contains the raw HTTP response sent by the server."
  (switch-to-buffer (current-buffer)))

(provide 'essay)