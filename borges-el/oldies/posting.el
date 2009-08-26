(require 'http-post-simple)
(require 'url-auth)			
(defun blog-post ()
  (interactive)				
;;;   (url-auth-user-prompt "http://blogurl.com/admin/" "")
  (http-post-simple "http://localhost:3005/essays.xml" (append(get-parms))))

(defun get-parms ()
  (list (cons 'essay%5Bcontent%5D (buffer-string))
    (cons 'essay%5Btitle%5D (read-from-minibuffer "Post title: "))))

;; esto me da un buffer con el xml sin parsear C-x-e
;; (url-retrieve "http://localhost:3000/essays/1.xml" 'my-switch-to-url-buffer)

(defun my-switch-to-url-buffer (status)
  "Switch to the buffer returned by `url-retreive'.
    The buffer contains the raw HTTP response sent by the server."
  (switch-to-buffer (current-buffer)))


;; This is another example using only the url library 

