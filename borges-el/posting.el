(require 'http-post-simple)
(require 'url-auth)
(defun blog-post ()
  (interactive)
;;;   (url-auth-user-prompt "http://blogurl.com/admin/" "")
  (http-post-simple "http://localhost:3005/essays.xml" (append(get-parms))))

(defun get-parms ()
  (list (cons 'essay%5Bcontent%5D (buffer-string))
    (cons 'essay%5Btitle%5D (read-from-minibuffer "Post title: "))))


